# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    trait :development_category do 
      name { 'Development' }  
    end 

    trait :product_category do
      name { 'Product' }
    end

    trait :design_category do
      name { 'Design' }
    end
  end
end