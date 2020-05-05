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

    trait :full_time do
      association :job_type, :full_time_type
    end

    trait :part_time do
      association :job_type, :part_time_type
    end

    trait :freelance do
      association :job_type, :freelance_type
    end

    trait :junior do
      association :level, :junior_level
    end

    trait :intermediate do
      association :level, :intermediate_level
    end

    trait :senior do
      association :level, :senior_level
    end

    trait :development do
      association :category, :development_category
    end

    trait :product do
      association :category, :product_category
    end

    trait :design do
      association :category, :design_category
    end
  end
end