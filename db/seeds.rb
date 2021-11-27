
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.where(internal_name: "web_development").first_or_create(name: "Web development", internal_name: "web_development")
Category.where(internal_name: "design").first_or_create(name: "Design", internal_name: "design")
Category.where(internal_name: "product").first_or_create(name: "Product", internal_name: "product")
Category.where(internal_name: "engineering").first_or_create(name: "Engineering", internal_name: "engineering")
Category.where(internal_name: "sales").first_or_create(name: "Sales", internal_name: "sales")
Category.where(internal_name: "management").first_or_create(name: "Management", internal_name: "management")
Category.where(internal_name: "marketing").first_or_create(name: "Marketing", internal_name: "marketing")
Category.where(internal_name: "data").first_or_create(name: "Data", internal_name: "data")

JobType.where(internal_name: "full_time").first_or_create(name: "Full-time", internal_name: "full_time")
JobType.where(internal_name: "part_time").first_or_create(name: "Part-time", internal_name: "part_time")
JobType.where(internal_name: "freelance").first_or_create(name: "Freelance", internal_name: "freelance")
JobType.where(internal_name: "internship").first_or_create(name: "Internship", internal_name: "internship")

Level.where(internal_name: "junior").first_or_create(name: "Junior", internal_name: "junior")
Level.where(internal_name: "intermediate").first_or_create(name: "Intermediate", internal_name: "intermediate")
Level.where(internal_name: "senior").first_or_create(name: "Senior", internal_name: "senior")

UserType.where(internal_name: "candidate").first_or_create(name: "Candidate", internal_name: "candidate")
UserType.where(internal_name: "company").first_or_create(name: "Company", internal_name: "company")
UserType.where(internal_name: "admin").first_or_create(name: "Admin", internal_name: "admin")
UserType.where(internal_name: "ambassador").first_or_create(name: "Ambassador", internal_name: "ambassador")

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

50.times do
  User.create(email: Faker::Internet.email,
              name: Faker::Name.name,
              last_name: Faker::Name.last_name,
              phone: Faker::PhoneNumber.phone_number,
              description: Faker::Lorem.paragraph,
              personal_website: Faker::Internet.domain_name,
              github: Faker::Internet.domain_name,
              pinterest: Faker::Internet.domain_name,
              behance: Faker::Internet.domain_name,
              salary_from: Faker::Number.number(digits: 5),
              salary_to: Faker::Number.number(digits: 5),
              password: "12345678", 
              user_type_id: 1,
            )
end

User.where(email: "candidate@email.com").first_or_create(name: "Pol Candidate", password: "12345678", user_type_id: 1)
User.where(email: "company@email.com").first_or_create(name: "Pol Company", password: "12345678", user_type_id: 2)
User.where(email: "admin2@email.com").first_or_create(name: "Pol Admin", password: "12345678", user_type_id: 3)

10.times do 
  User.create(email: Faker::Internet.email, password: "123456", user_type_id: 2)
end

50.times do 
  sleep 0.4
  Job.create(reference: "wah#{DateTime.now.year}#{SecureRandom.hex(3)}",
            title: Faker::Job.title,
            description: Faker::Lorem.paragraph(sentence_count: 2),
            salary_from: rand(20000..30000),
            salary_to: rand(40000..80000),
            location: location.sample,
            url: "https://www.google.com",
            apply_url: "https://www.google.com",
            job_author: Faker::Name.name,
            remote_ok: false,
            expiry_date: Faker::Date.between(from: 2.days.ago, to: 60.days.from_now),
            user_id: rand(1..10),
            category_id: rand(1..7),
            job_type_id: rand(1..3),
            level_id: rand(1..3)
          )
end