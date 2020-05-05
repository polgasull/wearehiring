# frozen_string_literal: true

FactoryBot.define do
  factory :level do
    trait :junior_level do 
      internal_name { 'junior' }
      name          { 'Junior' }  
    end 

    trait :intermediate_level do
      internal_name { 'intermediate' }
      name { 'Intermediate' }
    end

    trait :senior_level do
      internal_name { 'senior' }
      name { 'Senior' }
    end
  end
end