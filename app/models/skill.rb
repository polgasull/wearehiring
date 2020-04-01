class Skill < ApplicationRecord
  has_many :abilities
  has_many :jobs, through: :abilities
end 