class OpenaiService
  def initialize(selected_prerequisite)
    @selected_prerequisite = selected_prerequisite
    @client = OpenAI::Client.new
  end

  def persona
    <<~PERSONA
    You are a Tender Analysis & Writing Expert for Building and Construction.

    You specialize in reading, evaluating, and writing tender documents to ensure they align with industry best practices, regulatory requirements,
    and project feasibility. Your expertise lies in identifying gaps, inconsistencies, and risks within tender documents and refining them to enhance clarity, compliance, and enforceability.

    Your Key Skills & Approach:
      •	Tender Analysis: You critically assess tender documents to identify missing, vague, or contradictory requirements that could create project risks.
      •	Regulatory & Contractual Compliance: You ensure tenders align with relevant standards, such as FIDIC, NEC, JCT, and local procurement regulations.
      •	Best Practice Enhancement: You refine tender documents to incorporate clear deliverables, well-defined evaluation criteria, and structured pricing models.
      •	Strategic Tender Writing: You rewrite tenders to improve precision, readability, and alignment with project objectives.
      •	Bid Optimization: You assist bidders in crafting compelling, compliant responses that maximize their scoring potential.

      You work methodically, using structured frameworks such as risk assessments, scoring matrices, and compliance checklists.
      Your recommendations balance legal precision, commercial viability, and practical execution to ensure tenders are robust, fair, and effective.
    PERSONA
  end

  def analyse
  instructions = <<~INSTRUCTIONS
    You are analyzing a requirement description from a tender specifications document. This description is typically copy-pasted from a boilerplate template
    and may not accurately reflect the specific needs of the project. Your goal is to assess and enhance its clarity, alignment with industry best practices,
    and relevance to the project’s objectives.

    Analysis Steps:
    1. Compare the inputted requirement description with:
      •	The requirement title (to ensure adherence to industry best practices for that type of requirement).
      •	The project synopsis (to evaluate alignment with the project’s objectives and intended outcomes).
	  2. Identify gaps and areas for improvement based on:
      •	Industry standards and best practices relevant to the requirement title.
      •	The specific context and goals outlined in the project synopsis.
	  3.Draft a concise report (max. 250 words) structured with bullet points and subheadings.
      •	Highlight missing details, ambiguities, or inconsistencies.
      •	Suggest specific improvements to enhance clarity, completeness, and relevance.

    Maintain a professional and objective tone while ensuring the recommendations are practical and actionable.

    The inputted description is:

    #{@selected_prerequisite.description}

    The requirement title is:

    #{@selected_prerequisite.prerequisite.name}

    The project synopsis is:

    #{@selected_prerequisite.tender.synopsis}
    INSTRUCTIONS

    chatgpt_response = @client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
  end

  def rewrite
    instructions = <<~INSTRUCTIONS
    Rewrite the inputted description based on the result of the analysis.

    The inputted description is:

    #{@selected_prerequisite.description}

    The analysis is:

    #{@selected_prerequisite.analysis}
    INSTRUCTIONS


    chatgpt_response = @client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
  end
end
