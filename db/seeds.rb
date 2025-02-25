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

puts "users created..."

puts "creating tenders..."
5.times do
  User.where(owner: true).each do |user|
    tender = Tender.new(
      user: user,
      synopsis: Faker::Quotes::Shakespeare.hamlet_quote,
      title: Faker::Book.author,
      published: true,

    )
    tender.save!
  end
end

5.times do
  User.where(owner: true).each do |user|
    tender = Tender.new(
      user: user,
      synopsis: Faker::Quotes::Shakespeare.hamlet_quote,
      title: Faker::Book.author,
      published: false
    )
    tender.save!
  end
end
puts "tenders created..."

puts "creating submissions..."

5.times do
  User.where(owner: false).each do |user|
    submission = Submission.new(
      user: user,
      published: true,
      shortlisted: true
    )
    submission.save!
  end
end

5.times do
  User.where(owner: false).each do |user|
    submission = Submission.new(
      user: user,
      published: false,
      shortlisted: false
    )
    submission.save!
  end
end
puts "submissions created..."

puts "creating selected prerequisites..."


5.times do
  Tender.each do |tender|
    selected_prerequisite = SelectedPrerequisite.new(
      tender: tender,
      prerequisite_id: PREREQUISITES.sample.index,
      description: Faker::Quotes::Chiquito.sentence,
      approved: true
    )
    selected_prerequisite.save!
  end
end

5.times do
  Tender.each do |tender|
    selected_prerequisite = SelectedPrerequisite.new(
      tender: tender,
      prerequisite_id: PREREQUISITES.sample.index,
      description: Faker::Quotes::Chiquito.sentence,
      approved: false
    )
    selected_prerequisite.save!
  end
end
puts "selected prerequisites created..."

puts "creating compatible responses..."

5.times do
  Submission.tender.selected_prerequisite.each do |selected_prerequisite|
    compatible_response = CompatibleResponse.new(
      selected_prerequisite: selected_prerequisite,
      submission: selected_prerequisite.submission,
      notes: Faker::Fantasy::Tolkien.poem,
      score: rand(1..100)
    )
    compatible_response.save!
  end
end
puts "compatible responses created!"

puts "created #{User.count}users, #{Tender.count}tenders, #{Submission.count}submissions, #{SelectedPrerequisite.count}selected prerequisites, and #{CompatibleResponse.count}compatible responses!"
