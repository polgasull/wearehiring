class Inscription < ApplicationRecord
  extend FilterBy

  belongs_to :job
  belongs_to :user

  validates_uniqueness_of :job_id, scope: :user_id

  enum status: { discarded: 0, in_process: 1, finalist: 2 }

  scope :by_country_code, -> (resident_country_code) {
    left_outer_joins(:user).
    where('users.resident_country_code = ?', resident_country_code)
  }

  scope :by_experience, -> (experience) {
    left_outer_joins(:user).
    where('users.experience = ?', experience)
  }

  scope :by_status, -> (status) {
    status_selected = Inscription.statuses[status]
    where('inscriptions.status = ?', status_selected)
  }
end
