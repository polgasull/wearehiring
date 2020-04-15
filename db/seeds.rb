
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.where(name: "Web development").first_or_create(name: "Web development")
Category.where(name: "Design").first_or_create(name: "Design")
Category.where(name: "Product").first_or_create(name: "Product")
Category.where(name: "Engineering").first_or_create(name: "Engineering")
Category.where(name: "Sales").first_or_create(name: "Sales")
Category.where(name: "Administrative").first_or_create(name: "Administrative")

JobType.where(name: "Full-time").first_or_create(name: "Full-time")
JobType.where(name: "Part-time").first_or_create(name: "Part-time")
JobType.where(name: "Freelance").first_or_create(name: "Freelance")

UserType.where(name: "Candidate").first_or_create(name: "Candidate")
UserType.where(name: "Company").first_or_create(name: "Company")

location = [
  "Denver, CO", 
  "San Francisco, CA", 
  "Minneapolis, MN", 
  "New York, NY", 
  "Atlanta, GA",
  "Miami, FL",
  "Austin, TX",
  "Boston, MA"
]

User.where(email: "test@email.com").first_or_create(name: "Pol", password: "123456", user_type_id: 2)

10.times do 
  User.create(email: Faker::Internet.email, password: "123456", user_type_id: 2)
end

50.times do 
  sleep 0.4
  Job.create(title: Faker::Job.title,
            description: Faker::Lorem.paragraph(sentence_count: 2),
            budget: rand(20000..60000),
            location: location.sample,
            url: "https://www.google.com",
            apply_url: "https://www.google.com",
            job_author: Faker::Name.name,
            remote_ok: false,
            expiry_date: Faker::Date.between(from: 2.days.ago, to: 30.days.from_now),
            user_id: rand(1..10),
            category_id: rand(1..6),
            job_type_id: rand(1..3),
          )
end