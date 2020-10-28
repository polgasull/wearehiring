# frozen_string_literal: true

FactoryBot.define do
  factory :user_type do
    trait :admin_type do 
      internal_name { 'admin' }
      name          { 'Admin' }  
    end 

    trait :candidate_type do
      internal_name { 'candidate' }
      name { 'Candidate' }
    end

    trait :company_type do
      internal_name { 'company' }
      name { 'Company' }
    end

    trait :ambassador_type do
      internal_name { 'ambassador' }
      name { 'Ambassador' }
    end
  end
end