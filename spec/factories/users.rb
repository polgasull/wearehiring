FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    stripe_id { 'ch_1GNHkYAHewiMFJ6ipCLLEPTu' }
    card_brand { 'Visa' }
    card_last4 { '4242' }
    card_exp_month { '4' }
    card_exp_year { '2022' }
  end
end