namespace :submission do
  desc "TODO"
  task create: :environment do
  bidder = User.find_by(email: "bidder@gmail.com")
  tender = Tender.last
  Submission.create!(
    tender: tender,
    user: bidder,
    published: true,
    shortlisted: true,
  )
  end
end
