# frozen_string_literal: true

FactoryBot.define do
  factory :job_type do
    trait :full_time_type do 
      name { 'Full-time' }  
    end 

    trait :part_time_type do
      name { 'Part-time' }
    end

    trait :freelance_type do
      name { 'Freelance' }
    end
  end
end