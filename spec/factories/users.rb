FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    picture_url { Faker::Internet.url }
    profile_url { Faker::Internet.url }
    password { Faker::Internet.password }
    stripe_id { 'ch_1GNHkYAHewiMFJ6ipCLLEPTu' }
    card_brand { 'Visa' }
    card_last4 { '4242' }
    card_exp_month { '4' }
    card_exp_year { '2022' }

    trait :admin do
      association :user_type, :admin_type
    end

    trait :candidate do
      association :user_type, :candidate_type
    end

    trait :company do
      association :user_type, :company_type
    end
  end
end