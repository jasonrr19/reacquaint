require "open-uri"
require "pdf-reader"

class OpenaiService
  def initialize(attrs = {})
    @selected_prerequisite = attrs[:selected_prerequisite]
    @compatible_response = attrs[:compatible_response]
    @tender = attrs[:tender]
    @employee = attrs[:employee]
    @client = OpenAI::Client.new
  end

  def categories
    ["Health & Safety"]
  end

  # Personae
  def owner_persona
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

  def bidder_persona
    <<~PERSONA
    You are an expert in crafting compelling, compliant, and strategically optimized bid responses for construction, civil engineering, and infrastructure tenders.
    Your expertise lies in translating technical requirements into persuasive proposals that align with evaluation criteria, maximize scoring potential,
    and differentiate your bid from competitors.

    Your Key Skills & Approach:
	  •	 Bid Strategy & Win Themes: You develop tailored bid strategies that highlight competitive strengths, unique value propositions, and alignment with client priorities.
	  •	 Compliance & Evaluation Alignment: You meticulously ensure bid responses meet all contractual, technical, and regulatory requirements (e.g., FIDIC, NEC, JCT).
	  •	 Persuasive & Clear Writing: You craft clear, concise, and engaging responses that effectively communicate capability, experience, and project approach.
	  •	 Technical & Commercial Integration: You collaborate with technical and commercial teams to produce well-balanced bids that are both technically sound and commercially competitive.
	  • Risk & Gap Analysis: You assess tender documents to identify risks, ambiguities, and compliance challenges, ensuring mitigation strategies are embedded in the bid.
	  •	Bid Review & Scoring Optimization: You refine submissions to enhance readability, clarity, and alignment with scoring methodologies.

    You work systematically, leveraging bid frameworks, compliance checklists, and evaluation matrices to ensure every response is compelling, precise, and aligned with the client’s objectives.
    Your approach balances persuasive writing with technical accuracy, ensuring that bids are not only compliant but also stand out as winning proposals.
    PERSONA
  end

  # Tender & Selected Prerequisites (Original)
  def analyse
    instructions = <<~INSTRUCTIONS
    Here’s the rewritten prompt from a bidder’s perspective:

    Bidder’s Requirement Analysis Guide

    You are analyzing a requirement description from a tender specifications document from a bidder’s perspective.
    This description is typically copy-pasted from a boilerplate template and may contain ambiguities, unrealistic expectations, or
    gaps in critical details. Your goal is to assess the requirement to identify key considerations for a bidder, including risks, challenges,
    important insights, resource needs, and other relevant factors.

    Analysis Steps:
      1.	Contextual Review:
      •	Compare the requirement description against:
      •	The requirement title (to understand its intent and standard industry expectations).
      •	The project synopsis (to assess alignment with the overall objectives and scope).
      2.	Bidder’s Considerations:
      •	Identify potential risks, ambiguities, and unrealistic expectations.
      •	Highlight operational, financial, or technical challenges bidders may face.
      •	Note any critical missing information that could impact bid preparation.
      •	Identify key resources (staff, materials, technology, certifications, etc.) that bidders should anticipate needing.
      •	Point out any aspects requiring clarification through bidder queries.
      3.	Concise Report (max. 250 words):
      •	Use bullet points, spacing, and subheadings for readability.
      •	Summarize key risks and challenges.
      •	Highlight critical insights and strategic considerations for bidders.
      •	List recommended questions or clarifications to seek from the issuer.

    Maintain a professional and objective tone while ensuring the analysis is practical, actionable, and directly relevant to bid preparation.

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
        { role: "user", content: bidder_persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(@result)
  end

  def rewrite
    instructions = <<~INSTRUCTIONS
    Rewrite the inputted description based on the result of the analysis.
    Rewrite to be as comprehensive as possible but do not exceed 1000 words.
    Use formatting for headers, italics, bolding, and bullet points as appropriate.
    Have spacing to improve readability.

    The inputted description is:

    #{@selected_prerequisite.description}

    The analysis is:

    #{@selected_prerequisite.analysis}
    INSTRUCTIONS


    chatgpt_response = @client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: owner_persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(@result)
  end

  # Tender & Selected Prerequisites (New)
  def spq_read
    url = @tender.document.url
    file = URI.open(url)
    pdf = PDF::Reader.new(file)
    pdf_text = pdf.pages.map(&:text).join("\n\n")
    Prerequisite.order(id: :asc).find_each do |prerequisite|
      SelectedPrerequisiteCreationJob.perform_later(pdf_text, @tender, prerequisite, owner_persona)
    end
    SynopsisCreationJob.perform_later(@tender)
    SubmissionCreationJob.perform_later(@tender)
  end

  def tender_brief
    concat_descriptions = ""
    @tender.selected_prerequisites do |spq|
      input = "
      #{spq.prerequisite.name}

      #{spq.description}
      "
      concat_descriptions += input
    end
      instructions = <<~INSTRUCTIONS
      Task:
        1.	Review the Tender Requirements
        •	Carefully read the consolidated descriptions of all prerequisites and requirements provided in the tender document.
        2.	Summarize Key Information
        •	Create a one-page executive summary of no less than 350 words (tender brief) that highlights essential details.
        •	Structure the summary into the following sections:
        •	Requirements: Core eligibility criteria and mandatory conditions.
        •	Key Points & Considerations: Important aspects, unique conditions, or critical evaluation criteria.
        •	Other Noteworthy Information: Additional details that may impact a bidder’s decision.
        3.	Objective:
        •	Ensure the summary allows prospective bidders to quickly assess if the tender is relevant and worth pursuing.
        •	Do not return thought process or any other commentary. Only return the executive summary.

      Source Material:
        •	The consolidated descriptions of all prerequisites and requirements are: #{concat_descriptions}.
      INSTRUCTIONS

      chatgpt_response = @client.chat(parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "user", content: owner_persona},
          { role: "user", content: instructions}
        ]
      })
      @result = chatgpt_response["choices"][0]["message"]["content"]
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
      @tender.synopsis = markdown.render(@result)
      @tender.save
      Turbo::StreamsChannel.broadcast_replace_to(
        "tender_#{@tender.id}_links",
        target: "tender-synopsis",
        partial: "tenders/synopsis",
        locals: { tender: @tender }
      )
  end

  # Submission & Compatible Responses (Original)
  def write
    instructions = <<~INSTRUCTIONS
    You are reviewing a tender document to assess its requirements and draft a strategically optimized bid response.
    Your goal is to ensure that the response is compliant, compelling, and aligned with evaluation criteria, maximizing its scoring potential.

    Analysis & Response Writing Steps:

    1. Requirement Analysis (do not return this but use it in drafting the bid response)
      •	Compare the requirement description with:
      •	The project synopsis (to ensure alignment with the overall project).
      •	The requirement title objectives (to highlight how the bid meets the title's goals).
      •	Identify ambiguities, missing details, or areas where clarification is needed.
      •	Assess the requirement against industry standards (e.g., FIDIC, NEC, JCT) and best practices.

    2. Bid Strategy & Optimization (do not return this but use it in drafting the bid response)
      •	Identify key win themes that differentiate the bid (e.g., innovation, sustainability, risk mitigation, cost-effectiveness).
      •	Ensure the response effectively addresses technical, commercial, and compliance aspects.
      •	Structure the bid to enhance clarity, readability, and persuasive impact.

    3. Drafting the Bid Response (Max. 250 Words)
      •	Use a structured format with bullet points and subheadings.
      •	Clearly articulate:
        •	Understanding of the requirement (demonstrating insight into project goals).
        •	Approach & Methodology (how the bidder will deliver the requirement efficiently).
        •	Experience & Capabilities (evidence of past success, qualifications, and technical expertise).
        •	Value Proposition (how the bid offers the best solution in terms of quality, cost, and risk management).
        •	Ensure concise, professional, and persuasive writing.

    Your recommendations should balance strategic persuasion and technical accuracy, ensuring the bid is compliant, competitive,
    and compelling while addressing all requirements effectively.

    The requirement description is:

    #{@selected_prerequisite.description}

    The requirement title is:

    #{@selected_prerequisite.prerequisite.name}

    The project synopsis is:

    #{@selected_prerequisite.tender.synopsis}
    INSTRUCTIONS

    chatgpt_response = @client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: bidder_persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    markdown.render(@result)
  end

  def score
    instructions = <<~INSTRUCTIONS
    You are reviewing a bidder's responses to requirements(selected prerequisites)
    and their descriptions on a project based on the following rubrics.
    Match the name on the rubric to the requirement title to which the response is made for the selected prerequisite
    and generate a numeric score ranging from 1 -100 based on how closely the response succeeds in satisfiying the conditions.
    Now take each score and generate an overall score that is the average of all scores.
    Please do not return any text, only an integer score between 1 - 100.

    The requirement description is:

    #{@selected_prerequisite.description}

    The requirement title is:

    #{@selected_prerequisite.prerequisite.name}r
    INSTRUCTIONS

    chatgpt_response = @client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [
        { role: "user", content: bidder_persona},
        { role: "user", content: instructions}
      ]
    })
    @result = chatgpt_response["choices"][0]["message"]["content"]
  end

  # Submission & Compatible Responses (New)

  # Users & Employees
  def check_compatible
    employee = @employee
    prerequisites = ""
    Prerequisite.all.each do |prereq|
      prerequisites += "#{prereq.name}, "
    end
    instructions = <<~INSTRUCTIONS
      Task:
        1.	You will use the Source Material below to report the relevance of an employee in a construction project for future tender bids.
        •	Carefully read the job title, job description, and experience of the employee from the Source Material.
        2.	Based on the job title, job description, and experience of the employee from the Source Material, draft a relevance write-up
        •	The relevance write-up should clearly describe the role, skillset, and experience of the employee from a bidding point of view.
        •	The relevance write-up must also describe the kinds of projects (typologies, industry, sector, scale) that the employee is suited for.
        •	The relevance write-up must clearly state which prerequisite the employee is best suited for, choosing from one of the prerequisites in the Source Material.
        •	The relevance write-up must have no formatting or headings of any kind and should be plain text in paragraph form.
        •	The relevance write-up should not be more than 200 words.

      Source Material:
        •	The job title of the employee is:
        #{employee.job_title}

        •	The job description of the employee is:
        #{employee.job_description}

        •	The experience of the employee is:
        #{employee.experience}

        •	The prerequisites are:
        #{prerequisites}

      INSTRUCTIONS

      chatgpt_response = @client.chat(parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "user", content: bidder_persona},
          { role: "user", content: instructions}
        ]
      })
      @result = chatgpt_response["choices"][0]["message"]["content"]
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
      markdown.render(@result)
  end

end
