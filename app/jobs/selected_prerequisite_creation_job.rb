require "pdf-reader"

class SelectedPrerequisiteCreationJob < ApplicationJob
  queue_as :default

  def perform(client, pdf_text, tender, prerequisite, owner_persona)
    client = OpenAI::Client.new
    instructions = <<~INSTRUCTIONS
      Analyze the provided PDF text and extract only the content directly relevant to the given prerequisite title: #{prerequisite.name}.
      Focus on sections, paragraphs, or points that explicitly mention, explain, or build upon this prerequisite.
      Ignore unrelated or loosely connected content. If relevant information is scattered, consolidate it into a structured summary.
      Retain key details, technical terms, and any examples that clarify the prerequisite's role.
      Ensure coherence and completeness while avoiding redundant or extraneous material.

      The PDF text is #{pdf_text}
      INSTRUCTIONS

    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: owner_persona},
        { role: "user", content: instructions}
      ]
    })

    result = chatgpt_response["choices"][0]["message"]["content"]
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)

    SelectedPrerequisite.create(description: markdown.render(result), tender: tender, prerequisite: prerequisite)
    Turbo::StreamsChannel.broadcast_replace_to(
      "tender_#{tender.id}_links",
      target: "spq-index-links",
      partial: "tenders/spq_index_links",
      locals: { tender: tender }
    )
  end
end
