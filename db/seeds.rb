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
[true, false].each do |boolean|
  User.where(owner: true).each do |user|
    tender = Tender.new(
      user: user,
      title: Faker::Address.community,
      synopsis: "We invite experienced contractors to submit bids for the renovation of this project. The scope of work includes structural repairs, interior and exterior upgrades, and improvements to safety and accessibility features.",
      published: boolean
    )
    tender.save!
    Prerequisite.all.shuffle.first(4).each do |prerequisite|
      selected_prerequisite = SelectedPrerequisite.new(
        tender: tender,
        prerequisite: prerequisite,
        description: "Contractors must demonstrate relevant qualifications and experience, and ensure that environmental considerations are integrated into the project to minimize impact. Proposals should reflect these priorities to ensure the successful completion of the project within established guidelines.",
        approved: boolean
      )
      selected_prerequisite.save!
    end
  end
end
puts "#{Tender.count} tenders created..."

puts "creating submissions..."

# simulating a completed bid process for contractor right cool.
User.where(owner: false).each do |user|
  tender = Tender.all.sample
  submission = Submission.new(
    tender: tender,
    user: user,
    published: true,
    shortlisted: true
  )
  submission.save!
  tender.selected_prerequisites.each do |prereq|
    compatible_response = CompatibleResponse.new(
      selected_prerequisite: prereq,
      submission: submission,
      notes: "We are pleased to submit our proposal for the renovation project, fully aligning with the specified prerequisites. Our team prioritizes health and safety by implementing rigorous protocols and training.",
      score: rand(1..100)
    )
    compatible_response.save!
  end
end
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

# Create a set of employees for bidder user
bidder = User.where(email: "bidder@gmail.com").first
jd = <<~JD
  The Health & Safety Manager ensures workplace safety and compliance with Indian regulations, including the Factories Act, 1948, and relevant state laws.
  Responsibilities include developing and implementing health and safety policies, conducting risk assessments, training employees on safety procedures, investigating incidents, and maintaining records.
  They work closely with management to foster a strong safety culture and ensure adherence to industry standards such as BIS and ISO.
  The role involves identifying hazards, recommending corrective actions, and overseeing emergency response plans.
  Strong knowledge of Indian labour laws, excellent communication skills, and experience in health and safety management are essential.
  JD

xp = <<~XP
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
  job_description: jd,
  experience: xp,
  user: bidder
)
employee.save!

puts "Created Sam Patel"


# simulating a bid process that just started for a contractor right cool.
User.where(owner: false).each do |user|
  tender = Tender.where.not(id: user.tenders_as_bidder).sample
  submission = Submission.new(
    tender: tender,
    user: user,
    published: false,
    shortlisted: false
  )
  submission.save!
  tender.selected_prerequisites.each do |prereq|
    compatible_response = CompatibleResponse.new(
      selected_prerequisite: prereq,
      submission: submission
    )
    compatible_response.save!
    user.employees.sample(3)
    compatible_employee = CompatibleEmployee.new(
      why_compatible: "He has 20 years of experience",
      compatible_response: compatible_response,
      employee: employee
    )
    compatible_employee.save!
  end
end

puts "submissions created..."

puts "creating selected prerequisites..."

puts "selected prerequisites created..."

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
puts "created  #{Employee.count}employees,  #{CompatibleEmployee.count} compatible employees"
