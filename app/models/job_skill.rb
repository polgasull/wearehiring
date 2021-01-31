# frozen_string_literal: true

class JobSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :job

  validates :skill_id, uniqueness: { scope: :job_id }
  validates :job_id, uniqueness: { scope: :skill_id }
end
