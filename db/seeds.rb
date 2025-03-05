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
  password: "123123"
)

puts "creating bidder user..."
bidder = User.new(
  company_name: "Bidder Limited",
  email: "bidder@gmail.com",
  address: "Bidder Lane, Bidderburg",
  owner: false,
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
User.where(owner: false).each do |user|
  # Create a set of employees for each bidder
  5.times do |i|  # You can adjust the number of employees per bidder here
    employee = Employee.new(
      user: user,
      name: Faker::Name.name,
      job_title: ["Project Manager", "Engineer", "Architect", "Site Supervisor", "Estimator"].sample,
      job_description: "Responsible for various tasks related to the construction project.",
      experience: "#{:name} brings a wealth of experience to the team, having developed a deep understanding and expertise over the course of their extensive career in the industry."
    )
    employee.save!
  end
end
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
      employee: user.employees.sample
    )
    compatible_employee.save!
  end
end

puts "submissions created..."

puts "creating selected prerequisites..."

puts "selected prerequisites created..."

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
puts "created  #{Employee.count}employees,  #{CompatibleEmployee.count} compatible employees"
