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
User.destroy_all
Tender.destroy_all
Submission.destroy_all
SelectedPrerequisite.destroy_all
CompatibleResponse.destroy_all
puts "everything destroyed..."

PREREQUISITES = ["Safety", "budget control", "woman things", "man spaces", "art installation"]

puts "creating new instances..."
5.times do
  user = User.new(
    company_name: Faker::Company.name,
    email: Faker::Internet.email(domain: 'gmail.com'),
    address: Faker::Address.street_address,
    owner: true
  )
  user.save!
  end
  5.times do
    user = User.new(
      company_name: Faker::Company.name,
      email: Faker::Internet.email(domain: 'gmail.com'),
      address: Faker::Address.street_address,
      owner: false
    )
    user.save!
  end

puts "users created..."

puts "creating tenders..."
5.times do
  tender = Tender.new(
    synopsis: Faker::Quotes::Shakespeare.hamlet_quote(minimum: 100),
    title: Faker::Book.author,
    published: true
  )
  tender.save!
end

5.times do
  tender = Tender.new(
    synopsis: Faker::Quotes::Shakespeare.hamlet_quote(minimum: 100),
    title: Faker::Book.author,
    published: false
  )
  tender.save!
end
puts "tenders created..."

puts "creating submissions..."

5.times do
  submission = Submission.new(
    published: true,
    shortlisted: true
  )
  submission.save!
end

5.times do
  submission = Submission.new(
    published: false,
    shortlisted: false
  )
  submission.save!
end

puts "submissions created..."

puts "creating selected prerequisites..."

5.times do
  selected_prerequisite = SelectedPrerequisite.new(
    description: Faker::Quotes::Chiquito.sentence,
    approved: true
  )
  selected_prerequisite.save!
end

5.times do
  selected_prerequisite = SelectedPrerequisite.new(
    description: Faker::Quotes::Chiquito.sentence,
    approved: false
  )
  selected_prerequisite.save!
end

puts "selected prerequisites created..."

puts "creating compatible responses..."
5.times do
  compatible_response = CompatibleResponse.new(
    notes: Faker::Fantasy::Tolkien.poem,
    score: rand(1..100)
  )
  compatible_response.save!
end

puts "compatible responses created!"

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
