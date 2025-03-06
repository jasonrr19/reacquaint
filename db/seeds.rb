require "open-uri"
require 'faker'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "destroying everything..."
CompatibleEmployee.destroy_all
CompatibleResponse.destroy_all
SelectedPrerequisite.destroy_all
Submission.destroy_all
Tender.destroy_all
Employee.destroy_all
User.destroy_all
Prerequisite.destroy_all
puts "everything destroyed..."

PREREQUISITES = [
  { name: "budget control", fa_class: "fa-regular fa-money-bill-1"},
  { name: "environment", fa_class: "fa-regular fa-sun" },
  { name: "health and safety", fa_class: "fa-regular fa-heart"},
  { name: "qualifications", fa_class: "fa-regular fa-clipboard"},
  { name: "quality", fa_class: "fa-regular fa-star"}
]
puts "creating prerequisites..."
Prerequisite.create!(PREREQUISITES)

puts "created #{Prerequisite.count} prerequisite"

puts "creating owner user..."
owner = User.new(
  company_name: "Owner Limited",
  email: "owner@gmail.com",
  address: "Owner Street, Ownersville",
  owner: true,
  password: "123123"
)
owner.save!

owner = User.new(
  company_name: "J Unlimited",
  email: "Junlimited@gmail.com",
  address: "1645 Hacienda Street, Las Vegas, Nevada",
  owner: true,
  admin: true,
  password: "123123"
)

puts "creating bidder user..."
bidder = User.new(
  company_name: "Bidder Limited",
  email: "bidder@gmail.com",
  address: "Bidder Lane, Bidderburg",
  owner: false,
  admin: true,
  password: "123123"
)
bidder.save!


puts "creating new users..."
5.times do
  user = User.new(
    company_name: Faker::Company.name,
    email: Faker::Internet.email(domain: 'gmail.com'),
    address: Faker::Address.street_address,
    owner: true,
    password: "123123"
  )
  user.save!
end
5.times do
  user = User.new(
    company_name: Faker::Company.name,
    email: Faker::Internet.email(domain: 'gmail.com'),
    address: Faker::Address.street_address,
    owner: false,
    password: "123123"
  )
  user.save!
end

puts "#{User.count} users created..."

puts "creating tenders..."
# [true, false].each do |boolean|
#   User.where(owner: true).each do |user|
#     tender = Tender.new(
#       user: user,
#       title: Faker::Address.community,
#       synopsis: "We invite experienced contractors to submit bids for the renovation of this project. The scope of work includes structural repairs, interior and exterior upgrades, and improvements to safety and accessibility features.",
#       published: boolean
#     )
#     tender.save!
#     Prerequisite.all.shuffle.first(4).each do |prerequisite|
#       selected_prerequisite = SelectedPrerequisite.new(
#         tender: tender,
#         prerequisite: prerequisite,
#         description: "Contractors must demonstrate relevant qualifications and experience, and ensure that environmental considerations are integrated into the project to minimize impact. Proposals should reflect these priorities to ensure the successful completion of the project within established guidelines.",
#         approved: boolean
#       )
#       selected_prerequisite.save!
#     end
#   end
# end
# puts "#{Tender.count} tenders created..."

tender1 = Tender.new(
  user: bidder,
  title: "Construction of Flyover at chainage Km 165.020 (Pastikudi) on NH-26",
  published: true
)
file = File.open(File.join(Rails.root,'app/assets/images/patikudi_flyover.pdf'))
tender1.document.attach(io: file, filename: "tender.pdf", content_type: "application/pdf")
tender1.save!

sleep(30)

tender2 = Tender.new(
  user: bidder,
  title: "Reconstruction of Damaged Bridges on NH-326",
  published: true
)
file = File.open(File.join(Rails.root,'app/assets/images/nh_326_reconstruction.pdf'))
tender2.document.attach(io: file, filename: "tender.pdf", content_type: "application/pdf")
tender2.save!

sleep(30)

tender3 = Tender.new(
  user: bidder,
  title: "Design and Construction of Ross Park Change Rooms Building.",
  published: true
)
file = File.open(File.join(Rails.root,'app/assets/images/alice_springs.pdf'))
tender3.document.attach(io: file, filename: "tender.pdf", content_type: "application/pdf")
tender3.save!

sleep(30)

# puts "creating submissions..."

# simulating a completed bid process for contractor right cool.
# User.where(owner: false).each do |user|
#   tender = Tender.all.sample
#   submission = Submission.new(
#     tender: tender,
#     user: user,
#     published: true,
#     shortlisted: true
#   )
#   submission.save!
#   tender.selected_prerequisites.each do |prereq|
#     compatible_response = CompatibleResponse.new(
#       selected_prerequisite: prereq,
#       submission: submission,
#       notes: "We are pleased to submit our proposal for the renovation project, fully aligning with the specified prerequisites. Our team prioritizes health and safety by implementing rigorous protocols and training.",
#       score: rand(1..100)
#     )
#     compatible_response.save!
#   end
# end
# User.where(owner: false).each do |user|
#   # Create a set of employees for each bidder
#   5.times do |i|  # You can adjust the number of employees per bidder here
#     employee = Employee.new(
#       user: user,
#       name: Faker::Name.name,
#       job_title: ["Project Manager", "Engineer", "Architect", "Site Supervisor", "Estimator"].sample,
#       job_description: "Responsible for various tasks related to the construction project.",
#       experience: "#{name} brings a wealth of experience to the team, having developed a deep understanding and expertise over the course of their extensive career in the industry."
#     )
#     employee.save!
#   end
# end

# Create a set of health and safety employees for bidder user
bidder = User.where(email: "bidder@gmail.com").first
jd_sp = <<~JD
  The Health & Safety Manager ensures workplace safety and compliance with Indian regulations, including the Factories Act, 1948, and relevant state laws.
  Responsibilities include developing and implementing health and safety policies, conducting risk assessments, training employees on safety procedures, investigating incidents, and maintaining records.
  They work closely with management to foster a strong safety culture and ensure adherence to industry standards such as BIS and ISO.
  The role involves identifying hazards, recommending corrective actions, and overseeing emergency response plans.
  Strong knowledge of Indian labour laws, excellent communication skills, and experience in health and safety management are essential.
  JD

xp_sp = <<~XP
  Sam Patel has over 10 years of experience in health and safety management across various industries, including manufacturing, construction, and logistics. He has a deep understanding of Indian safety regulations,
  including the Factories Act, 1948, the Occupational Safety, Health and Working Conditions Code, 2020, and relevant BIS and ISO standards. Throughout his career, Sam has successfully implemented health and safety policies,
  conducted risk assessments, and trained employees to foster a strong safety culture.

  In his most recent role as a Health & Safety Manager at a leading manufacturing firm, Sam developed and enforced safety procedures that led to a significant reduction in workplace accidents. He conducted thorough hazard assessments,
  ensured compliance with local and national safety regulations, and introduced a reporting system that improved incident tracking and response. Sam also collaborated with department heads to integrate safety practices into daily operations,
  reducing downtime and improving overall efficiency. His proactive approach to workplace safety earned him recognition for maintaining a safe and compliant work environment.

  Prior to this, Sam worked in the construction sector, where he was responsible for overseeing site safety across multiple projects. He developed site-specific safety plans, ensured proper use of personal protective equipment (PPE), and conducted regular safety drills.
  His ability to identify potential hazards and implement corrective measures helped reduce on-site incidents, improving worker confidence and project timelines. He also played a key role in ensuring compliance with government inspections and audits, successfully addressing
  regulatory requirements without delays or penalties.

  Earlier in his career, Sam held a safety officer role in the logistics industry, where he implemented training programs to educate employees on safe material handling, emergency response, and fire safety. His initiatives contributed to improved compliance with workplace safety standards
  and a noticeable decrease in injuries related to manual handling and equipment operation.

  Sam is well-versed in conducting safety audits, preparing reports, and working closely with regulatory authorities. He has led internal training sessions to enhance employee awareness of workplace hazards and has successfully managed emergency response plans in various high-risk environments.
  His strong analytical skills allow him to assess safety risks effectively, while his excellent communication abilities help him engage employees at all levels to create a culture of safety and compliance.

  With a proactive mindset and a commitment to continuous improvement, Sam remains dedicated to enhancing workplace safety standards. His experience across different industries, coupled with his knowledge of Indian safety laws and best practices, makes him a valuable asset in any organisation
  striving to prioritise health and safety in the workplace.
  XP

employee = Employee.new(
  name: "Sam Patel",
  job_title: "Health and Safety Manager",
  prerequisite: "health and safety",
  job_description: jd_sp,
  experience: xp_sp,
  user: bidder
)
employee.save!

puts "Created Sam Patel"

jd_db = <<~JD
  The Health & Safety Director is responsible for leading the organization’s health and safety strategy, ensuring compliance with Indian regulations, including the Factories Act, 1948, state-specific laws, and international standards such as BIS and ISO.
  This role involves developing and overseeing the implementation of enterprise-wide health and safety policies, conducting comprehensive risk assessments, and driving a proactive safety culture across all levels of the organization.
  The director will provide strategic guidance on hazard identification, mitigation measures, and compliance frameworks while collaborating with senior leadership to integrate safety into overall business operations. Responsibilities include designing and executing advanced training programs,
  leading high-level incident investigations, analyzing root causes, and enforcing preventive measures to ensure continuous improvement. The role also involves overseeing emergency response and crisis management protocols, ensuring business continuity, and
  engaging with regulatory authorities and industry bodies to maintain best practices. A strong command of Indian labor laws, occupational health regulations, and international safety standards is essential, along with proven leadership, strategic thinking, and the ability to influence and
   implement high-impact safety initiatives. Extensive experience in health and safety management within industrial, manufacturing, or corporate environments is required, along with exceptional communication and problem-solving skills.
  JD

xp_db = <<~XP
  Debraj Bhonsle is a highly experienced health and safety professional with over two decades of expertise in construction safety, risk management, and regulatory compliance across large-scale infrastructure and real estate projects. Throughout his career, he has played a pivotal role in developing and
  implementing comprehensive safety frameworks that align with Indian regulations, including the Factories Act, 1948, the Building and Other Construction Workers Act, and global safety standards such as BIS and ISO. His leadership has been instrumental in fostering a culture of proactive risk management, ensuring worker safety,
  and minimizing hazards in high-risk construction environments.

  Starting as a safety officer on major infrastructure projects, Debraj quickly gained recognition for his ability to assess site-specific risks and implement safety protocols that significantly reduced accidents. His expertise spans across high-rise construction, road and bridge projects, tunneling, and large-scale industrial developments, where he has
  successfully led teams in enforcing stringent safety measures. Over the years, he has been responsible for conducting detailed hazard assessments, ensuring strict compliance with scaffolding safety, fall protection, excavation protocols, and heavy equipment operation standards. His approach integrates modern safety technologies, including real-time monitoring,
  predictive analytics, and digital reporting systems, to enhance site safety and prevent incidents before they occur.

  As a senior health and safety executive, Debraj has designed and executed large-scale safety training programs for workers, supervisors, and project managers, focusing on behavioral safety, emergency response, and compliance with occupational health standards. He has led high-level incident investigations, developed root cause analyses, and
  enforced preventive actions to ensure continuous improvement. His experience also includes managing crisis response strategies, ensuring robust emergency preparedness plans, and maintaining strong coordination with regulatory authorities, contractors, and labor unions to uphold the highest safety standards.

  With a deep understanding of construction-related hazards and labor laws, Debraj has been actively involved in policy development, working closely with industry experts to enhance workplace safety regulations. His ability to align safety initiatives with project timelines and business objectives has led to a proven track record of reducing site accidents,
  improving regulatory compliance, and creating safer, more efficient work environments. Through his leadership, he continues to drive innovation in construction safety, ensuring that projects are completed with the highest standards of worker protection and operational excellence.
  XP

employee = Employee.new(
  name: "Debraj Bhonsle",
  job_title: "Health and Safety Director",
  prerequisite: "health and safety",
  job_description: jd_db,
  experience: xp_db,
  user: bidder
)
employee.save!

puts "Created Debraj Bhonsle"

jd_ms = <<~JD
  The Health and Safety Site Manager is responsible for ensuring compliance with all workplace safety regulations and industry standards on construction sites, including adherence to Indian laws such as the Factories Act, 1948, the Building and Other Construction Workers Act, and relevant BIS and ISO safety standards.
  This role involves implementing site-specific safety policies, conducting risk assessments, enforcing hazard control measures, and ensuring that all personnel adhere to established safety procedures. The manager will lead safety training sessions for workers and site supervisors, conduct daily safety inspections, and
  coordinate emergency response plans to mitigate risks and prevent workplace accidents. Responsibilities include investigating incidents, identifying root causes, and recommending corrective actions to improve overall safety performance. The role requires close collaboration with project managers, engineers, and
  regulatory bodies to ensure a safe and compliant work environment. Strong knowledge of construction safety regulations, experience in high-risk site management, and the ability to enforce safety protocols effectively are essential. The ideal candidate will have a proven track record in site safety leadership,
  excellent problem-solving skills, and the ability to foster a proactive safety culture across all levels of the workforce. is required, along with exceptional communication and problem-solving skills.
  JD

xp_ms = <<~XP
  Martin Setbon is an experienced Health and Safety Site Manager with a strong track record in ensuring safety compliance on large-scale construction projects. With over 15 years of experience in occupational health and safety, he has worked across diverse construction environments, including high-rise buildings, infrastructure developments,
  roadworks, and industrial facilities. His expertise lies in implementing rigorous safety protocols, conducting comprehensive risk assessments, and enforcing compliance with Indian safety regulations such as the Factories Act, 1948, the Building and Other Construction Workers Act, and international standards like BIS and ISO.

  Starting his career as a site safety officer, Martin quickly developed a reputation for his hands-on approach to mitigating risks and improving site safety culture. Over the years, he has been instrumental in leading safety initiatives that have significantly reduced accident rates and improved compliance with hazard control measures. His responsibilities
  have included overseeing fall protection systems, ensuring safe scaffolding and excavation practices, and enforcing the proper use of personal protective equipment (PPE). His ability to train and mentor workers and supervisors in safety best practices has led to a notable increase in awareness and adherence to safety protocols on construction sites.

  In his role as a Health and Safety Site Manager, Martin has conducted in-depth accident investigations, identifying root causes and implementing corrective measures to prevent future incidents. He has worked closely with project managers, engineers, and regulatory bodies to ensure safety policies are seamlessly integrated into daily site operations without compromising project timelines.
  His proactive approach includes implementing emergency response plans, conducting regular drills, and ensuring all workers are prepared for potential hazards.

  Martin is known for his leadership and ability to foster a strong safety-first culture on-site. He stays ahead of industry advancements by incorporating modern safety technologies, such as real-time monitoring systems and digital reporting tools, to enhance hazard detection and risk management. His deep understanding of construction safety, combined with his ability to lead teams effectively,
  has made him a key asset in maintaining safe, compliant, and efficient worksites. With a commitment to continuous improvement and worker protection, Martin Setbon remains a driving force in elevating health and safety standards in the construction industry.
  XP

employee = Employee.new(
  name: "Martin Setbon",
  job_title: "Health and Safety Site Manager",
  prerequisite: "health and safety",
  job_description: jd_ms,
  experience: xp_ms,
  user: bidder
)
employee.save!

puts "Created Martin Setbon"

# Create a set of budget control employees for bidder user
jd_rc = <<~JD
  The Cost and Procurement Manager for road construction projects is responsible for overseeing cost estimation, budget control, and procurement processes to ensure efficient resource allocation and financial management. This role involves developing and implementing cost-control strategies, managing vendor negotiations, and ensuring procurement
  activities align with project timelines and regulatory requirements in India. The manager will be responsible for evaluating supplier contracts, optimizing material procurement, and ensuring compliance with government regulations, including the Indian Contract Act, procurement policies under NHAI and PWD guidelines, and other relevant road construction standards.
  Key responsibilities include conducting cost-benefit analyses, monitoring project expenditures, and mitigating financial risks by ensuring competitive pricing and quality assurance in procurement decisions. The role also involves collaborating with project managers, engineers, and finance teams to ensure seamless integration of cost and procurement strategies within
  overall project execution. Strong negotiation skills, a deep understanding of construction procurement regulations, and experience in managing large-scale road infrastructure budgets are essential. The ideal candidate will have a proven track record in cost management, supplier relationship management, and the ability to drive cost efficiency while maintaining quality
  and compliance in road construction projects.
  JD

xp_rc = <<~XP
  Remy Castella is a seasoned Cost and Procurement Manager with extensive experience in managing budgets, procurement strategies, and cost optimization for large-scale road construction projects across India. With over 18 years in the infrastructure sector, he has successfully led cost control and procurement operations for national highway projects, state road developments,
  and expressway expansions. His expertise lies in ensuring cost efficiency, negotiating optimal supplier contracts, and aligning procurement activities with government regulations, including the Indian Contract Act, NHAI and PWD guidelines, and industry standards for road construction.

  Beginning his career as a procurement officer in a major infrastructure firm, Remy quickly demonstrated his ability to analyze costs, streamline procurement processes, and secure high-quality materials at competitive prices. Over the years, he took on increasing responsibilities, overseeing multimillion-dollar budgets and managing procurement teams handling materials such as bitumen, aggregates, steel, and heavy equipment rentals.
  His ability to assess cost risks and implement financial controls has been critical in ensuring projects remain within budget while maintaining the highest quality and compliance standards.

  As a Cost and Procurement Manager, Remy has successfully led procurement negotiations with national and international vendors, ensuring that contracts are structured for long-term cost efficiency. His approach combines strategic sourcing, supplier performance evaluation, and cost-benefit analysis to optimize expenditures without compromising project timelines. He has played a key role in mitigating financial risks by implementing
  cost forecasting models, monitoring market fluctuations, and ensuring price stability through long-term procurement agreements.

  Remy’s strong collaboration with project managers, engineers, and finance teams has allowed him to align procurement strategies with overall project execution, ensuring seamless material availability and resource allocation. He has also been instrumental in introducing digital procurement systems and data-driven cost management practices, improving efficiency and transparency in project financials. His extensive knowledge of
  road construction procurement regulations, exceptional negotiation skills, and deep understanding of infrastructure cost dynamics have made him a vital asset in ensuring cost-effective and compliant road construction projects. Through his leadership, he continues to drive financial efficiency and strategic procurement excellence in the infrastructure sector.
  XP

employee = Employee.new(
  name: "Remy Castella",
  job_title: "Cost & Procurement Manager",
  prerequisite: "budget control",
  job_description: jd_rc,
  experience: xp_rc,
  user: bidder
)
employee.save!

puts "Created Remy Castella"

jd_as = <<~JD
  The Cost and Procurement Director for road construction projects is responsible for leading the overall cost management and procurement strategy, ensuring financial efficiency and regulatory compliance across large-scale infrastructure projects in India. This role involves setting procurement policies, optimizing supply chain operations, and overseeing cost-control frameworks to maintain
  budgetary discipline while ensuring project timelines are met. The director will manage high-value supplier negotiations, establish long-term procurement contracts, and ensure compliance with Indian government regulations, including NHAI and PWD procurement guidelines. Key responsibilities include risk assessment in cost planning, financial forecasting, supplier performance management,
  and driving value engineering initiatives to optimize project expenditures. The role requires close coordination with project stakeholders, finance teams, and government agencies to align procurement and cost strategies with overall project execution. Strong leadership skills, extensive experience in managing multi-billion-rupee budgets, and in-depth knowledge of road construction procurement
  laws and cost-control methodologies are essential. The ideal candidate will have a proven track record in leading large procurement teams, implementing cost-saving measures, and ensuring financial sustainability in infrastructure projects.
  JD

xp_as = <<~XP
  Anayat Sekhon is a highly accomplished Cost and Procurement Director with over 20 years of experience in managing large-scale road construction budgets, strategic sourcing, and financial planning. His expertise spans across national highways, expressways, and state road development projects, where he has successfully led cost-control initiatives and procurement strategies that have optimized
  resource allocation and ensured regulatory compliance. With a deep understanding of Indian infrastructure procurement policies, including NHAI and PWD guidelines, Anayat has been instrumental in securing long-term, cost-effective supplier contracts while maintaining high-quality standards in materials and services.

  Starting his career as a procurement officer in a leading infrastructure firm, Anayat quickly demonstrated his ability to negotiate competitive contracts, streamline supply chains, and implement cost-saving measures. Over the years, he progressed through senior roles, overseeing multi-billion-rupee budgets and managing procurement teams across multiple road projects. His leadership in financial risk
  assessment, cost forecasting, and supplier performance management has helped construction firms reduce expenses without compromising operational efficiency.

  As a Cost and Procurement Director, Anayat has played a pivotal role in aligning cost strategies with project execution, ensuring materials and services are procured efficiently to meet strict construction deadlines. He has spearheaded digital procurement systems, improving cost transparency and supplier accountability while enhancing procurement decision-making through data-driven insights.
  His strong collaboration with project managers, finance teams, and government agencies has led to improved compliance, reduced procurement risks, and greater financial efficiency across road construction projects. Known for his strategic mindset, negotiation skills, and ability to drive cost optimization, Anayat Sekhon continues to be a key leader in advancing procurement excellence in India’s infrastructure sector.
  XP

employee = Employee.new(
  name: "Anayat Sekhon",
  job_title: "Cost & Procurement Director",
  prerequisite: "budget control",
  job_description: jd_as,
  experience: xp_as,
  user: bidder
)
employee.save!

puts "Created Anayat Sekhon"

jd_gs = <<~JD
  The Cost and Procurement Analyst for road construction projects is responsible for supporting cost control and procurement activities by conducting financial analysis, evaluating supplier contracts, and ensuring cost-efficient procurement decisions. This role involves tracking project expenditures, performing cost-benefit analyses, and assisting in procurement planning to ensure material and service acquisitions
  align with budgetary constraints and regulatory requirements in India. The analyst will work closely with procurement managers and finance teams to analyze market trends, monitor supplier performance, and identify opportunities for cost savings. Key responsibilities include preparing cost reports, assisting in bid evaluations, ensuring compliance with NHAI and PWD procurement policies, and identifying potential risks in procurement
  strategies. The role requires strong analytical skills, attention to detail, and the ability to interpret financial data to support strategic procurement decisions. The ideal candidate will have experience in cost analysis, procurement processes, and a deep understanding of infrastructure project financing, making them a critical support function in ensuring cost efficiency in road construction projects.
  JD

xp_gs = <<~XP
  Gena Soh is a dedicated Cost and Procurement Analyst with a strong background in financial analysis, procurement planning, and cost control for road construction projects. With experience in managing procurement data, tracking project expenditures, and evaluating supplier contracts, she has contributed significantly to ensuring cost-efficient procurement processes in infrastructure development. Her expertise lies in analyzing financial risks,
  optimizing cost structures, and supporting procurement managers in making data-driven decisions that align with project budgets and regulatory requirements.

  Starting her career as a procurement coordinator, Gena quickly honed her skills in financial modeling, cost forecasting, and bid evaluation, making her an essential part of procurement operations in road construction firms. Over time, she has played a crucial role in assisting senior procurement managers with contract negotiations, monitoring supplier performance, and ensuring compliance with Indian procurement regulations, including NHAI and PWD policies.

  As a Cost and Procurement Analyst, Gena is responsible for preparing detailed cost reports, conducting cost-benefit analyses, and identifying opportunities for financial optimization in road infrastructure projects. She works closely with finance teams and project managers to track spending trends, assess market fluctuations, and implement data-driven strategies to improve procurement efficiency. Her ability to interpret complex financial data, coupled with her
  keen attention to detail, has helped ensure cost transparency and fiscal discipline in large-scale construction projects. With a strong foundation in procurement analytics and a proactive approach to financial risk management, Gena Soh continues to be a valuable asset in driving cost efficiency in road construction procurement.
  XP

employee = Employee.new(
  name: "Gena Soh",
  job_title: "Cost & Procurement Analyst",
  prerequisite: "budget control",
  job_description: jd_gs,
  experience: xp_gs,
  user: bidder
)
employee.save!

puts "Created Gena Soh"

# Create a set of environment employees for bidder user
jd_nr = <<~JD
  The Director of Environment for construction projects is responsible for overseeing environmental compliance, sustainability initiatives, and regulatory adherence across large-scale infrastructure developments. This role ensures that all construction activities align with Indian environmental laws, including the Environmental Protection Act, the Air and Water Acts, and regulatory guidelines from bodies such as the Central Pollution Control Board (CPCB)
  and the Ministry of Environment, Forest and Climate Change (MoEFCC). The director will develop and implement environmental management plans, monitor site conditions, and lead initiatives to minimize environmental impact, including waste management, air and water pollution control, and ecological preservation. Key responsibilities include conducting environmental risk assessments, ensuring regulatory reporting compliance, and integrating sustainable construction
  practices such as green building initiatives and carbon footprint reduction. This position requires close collaboration with project managers, government agencies, and environmental consultants to enforce best practices and drive continuous improvement in environmental performance. Strong leadership, expertise in environmental policy, and experience managing environmental impact assessments (EIAs) are essential. The ideal candidate will have a proven track record in
  implementing large-scale environmental strategies, leading teams, and ensuring regulatory compliance in the construction and infrastructure sector.
  JD

xp_nr = <<~XP
  Naveen Rathi is a highly experienced environmental leader with over 20 years of expertise in managing environmental compliance, sustainability programs, and regulatory adherence for large-scale construction projects. With a deep understanding of Indian environmental laws and international best practices, he has successfully led environmental initiatives for infrastructure projects, including highways, metro rail, and industrial developments.
  His expertise spans environmental risk management, regulatory compliance, and sustainable construction strategies that minimize ecological impact while ensuring project efficiency.

  Starting as an environmental consultant, Naveen quickly advanced through leadership roles, implementing environmental management plans that reduced pollution, optimized resource efficiency, and improved site sustainability. He has been instrumental in conducting Environmental Impact Assessments (EIAs), ensuring full compliance with CPCB and MoEFCC regulations, and integrating advanced waste management and water conservation techniques
  into construction processes. His strategic approach to sustainability has led to significant reductions in carbon footprints and improved ecological conservation measures on project sites.

  As a Director of Environment, Naveen collaborates closely with government agencies, construction teams, and environmental experts to ensure projects adhere to the highest environmental standards. He has introduced innovative green building practices, improved regulatory reporting accuracy, and championed training programs to enhance environmental awareness among project stakeholders. His leadership in environmental governance,
  combined with his ability to drive sustainable infrastructure development, makes him a key force in advancing environmentally responsible construction practices.
  XP

employee = Employee.new(
  name: "Naveen Rathi",
  job_title: "Environment Director",
  prerequisite: "environment",
  job_description: jd_nr,
  experience: xp_nr,
  user: bidder
)
employee.save!

puts "Created Naveen Rathi"

# Create a set of quality employees for bidder user
jd_rg = <<~JD
  The Director of Quality for construction projects is responsible for leading and overseeing quality control, assurance, and compliance initiatives across large-scale infrastructure developments. This role ensures that all construction activities adhere to national and international quality standards, including Indian Standards (BIS), IRC specifications, and ISO 9001 certification requirements. The director will develop and implement robust
  quality management systems, conduct audits, and establish best practices for materials testing, workmanship inspection, and defect prevention. Key responsibilities include ensuring compliance with regulatory guidelines, overseeing quality control teams, and driving continuous improvement through advanced quality methodologies such as Lean Construction and Six Sigma. The role also involves close collaboration with engineering teams, contractors,
  and government bodies to enforce quality standards and resolve non-compliance issues. Strong leadership skills, in-depth technical expertise, and experience in managing quality control frameworks for large-scale infrastructure projects are essential. The ideal candidate will have a proven track record in driving quality excellence, optimizing construction processes, and ensuring the highest standards of project delivery.
  JD

xp_rg = <<~XP
  Rajesh Gokhale is a highly accomplished quality management professional with over 25 years of experience in overseeing quality assurance, compliance, and process improvement for large-scale infrastructure projects. With a background in civil engineering and a specialization in quality control methodologies, he has led quality assurance teams for major road, bridge, and metro rail projects, ensuring adherence to national and
  international standards such as BIS, IRC specifications, and ISO 9001. His expertise in quality auditing, material testing, and process optimization has been instrumental in delivering defect-free, high-quality infrastructure.

  Beginning his career as a site quality engineer, Rajesh developed a deep technical understanding of construction materials, workmanship standards, and quality control mechanisms. Over time, he progressed to leadership roles, where he established comprehensive quality management systems, conducted large-scale quality audits, and introduced Lean Construction and Six Sigma principles to drive continuous improvement. His efforts have
  significantly reduced rework, improved construction efficiency, and enhanced overall project durability.

  As a Director of Quality, Rajesh works closely with project managers, government agencies, and contractors to enforce stringent quality standards and ensure compliance with all regulatory requirements. He has been responsible for implementing training programs to enhance workforce skills, streamlining inspection processes, and integrating digital quality management tools to improve monitoring and reporting accuracy. His strong leadership,
  combined with his unwavering commitment to quality excellence, continues to shape high-standard construction practices in India’s infrastructure sector.
  XP

employee = Employee.new(
  name: "Rajesh Gokhale",
  job_title: "Quality Director",
  prerequisite: "quality",
  job_description: jd_rg,
  experience: xp_rg,
  user: bidder
)
employee.save!

puts "Created Rajesh Gokhale"

# Create a set of qualifications employees for bidder user
jd_vs = <<~JD
  The Senior Executive – Director of Qualifications is responsible for overseeing the qualification, competency, and certification standards for construction professionals and workforce development in large-scale infrastructure projects. This role ensures that all engineers, technicians, and laborers meet industry-recognized skill benchmarks, including compliance with national construction training programs, safety certifications,
  and government-mandated competency standards. The director will design and implement professional development frameworks, manage certification processes, and work closely with regulatory bodies such as the National Skill Development Corporation (NSDC) and the Construction Skill Development Council of India (CSDCI) to ensure workforce readiness. Key responsibilities include developing technical training programs, enforcing contractor qualification criteria,
  and ensuring compliance with industry licensing requirements. The role requires strategic collaboration with engineering firms, academic institutions, and government agencies to enhance workforce capabilities and ensure that construction projects are executed by a highly skilled and certified workforce. Strong leadership in workforce development, expertise in construction qualifications, and experience in managing large-scale competency programs are essential.
  The ideal candidate will have a proven track record in skills enhancement, workforce policy development, and improving construction sector productivity through qualification and training initiatives.
  JD

xp_vs = <<~XP
  Vinay Sharma is a highly experienced workforce development leader with over 22 years of expertise in construction training, competency management, and professional certification programs. With a background in engineering and a specialization in workforce qualification standards, he has played a pivotal role in enhancing skills, ensuring certification compliance, and improving workforce competency across major infrastructure projects, including highways, metro systems,
  and industrial developments. His expertise spans training program development, regulatory compliance, and the implementation of construction qualification frameworks aligned with government and industry standards.

  Starting his career as a training coordinator, Vinay quickly advanced into leadership roles, where he designed and executed large-scale workforce development initiatives in collaboration with industry stakeholders. He has been instrumental in establishing certification programs for engineers, site supervisors, and laborers, ensuring compliance with NSDC and CSDCI requirements. His efforts have significantly improved workforce efficiency, reduced skill gaps, and
  increased safety compliance across construction sites.

  As a Senior Executive and Director of Qualifications, Vinay has worked closely with government agencies, academic institutions, and construction firms to create competency-based training models that align with industry demands. He has spearheaded initiatives to integrate digital learning platforms, modern apprenticeship programs, and standardized certification criteria to improve workforce readiness. His leadership in workforce qualification policies, commitment to skill enhancement,
  and ability to drive large-scale training initiatives have positioned him as a key force in advancing construction workforce excellence in India.
  XP

employee = Employee.new(
  name: "Vinay Sharma",
  job_title: "Qualifications Director",
  prerequisite: "qualifications",
  job_description: jd_vs,
  experience: xp_vs,
  user: bidder
)
employee.save!

puts "Created Vinay Sharma"



# simulating a bid process that just started for a contractor right cool.
# User.where(owner: false).each do |user|
#   tender = Tender.where.not(id: user.tenders_as_bidder).sample
#   submission = Submission.new(
#     tender: tender,
#     user: user,
#     published: false,
#     shortlisted: false
#   )
#   submission.save!
#   tender.selected_prerequisites.each do |prereq|
#     compatible_response = CompatibleResponse.new(
#       selected_prerequisite: prereq,
#       submission: submission
#     )
#     compatible_response.save!
#     user.employees.sample(3)
#     compatible_employee = CompatibleEmployee.new(
#       why_compatible: "He has 20 years of experience",
#       compatible_response: compatible_response,
#       employee: employee
#     )
#     compatible_employee.save!
#   end
# end

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
puts "created  #{Employee.count}employees,  #{CompatibleEmployee.count} compatible employees"
