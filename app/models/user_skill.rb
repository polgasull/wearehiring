# frozen_string_literal: true

class UserSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :user

  validates :skill_id, uniqueness: { scope: :user_id }
  validates :user_id, uniqueness: { scope: :skill_id }
end
