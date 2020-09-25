class Inscription < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates_uniqueness_of :job_id, scope: :user_id

  enum status: { discarded: 0, liked: 1, finalist: 2 }
end
