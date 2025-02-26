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
CompatibleResponse.destroy_all
SelectedPrerequisite.destroy_all
Submission.destroy_all
Tender.destroy_all
User.destroy_all
Prerequisite.destroy_all
puts "everything destroyed..."

PREREQUISITES = ["health and safety", "budget control", "quality", "qualifications", "environment"]
puts "creating prerequisites..."
PREREQUISITES.each do |name|
  Prerequisite.create!(name: name)
end

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
      synopsis: Faker::Quotes::Shakespeare.hamlet_quote,
      title: Faker::Book.author,
      published: boolean
    )
    tender.save!
    Prerequisite.all.shuffle.first(4).each do |prerequisite|
      selected_prerequisite = SelectedPrerequisite.new(
        tender: tender,
        prerequisite: prerequisite,
        description: Faker::Quotes::Chiquito.sentence,
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
      notes: Faker::Fantasy::Tolkien.poem,
      score: rand(1..100)
    )
    compatible_response.save!
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
  end
end
puts "submissions created..."

puts "creating selected prerequisites..."


puts "selected prerequisites created..."

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
