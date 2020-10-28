FactoryBot.define do
  factory :post do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
  end
end