class Tag < ApplicationRecord
  has_many :taggings
  has_many :jobs, through: :taggings
end 