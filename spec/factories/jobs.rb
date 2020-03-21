FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    url { 'https://www.google.com' }
    job_type { Faker::Job.employment_type }
    location { Faker::Nation.capital_city }
    job_author { Faker::App.author }
    remote_ok { Faker::Boolean.boolean }
    apply_url { 'https://www.google.com' }
    avatar { Faker::Avatar.image }
  end
end