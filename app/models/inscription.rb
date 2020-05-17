class Inscription < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates_uniqueness_of :job_id, scope: :user_id
end
