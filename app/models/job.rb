class Job < ApplicationRecord
  extend Filter

  belongs_to :user
  belongs_to :category
  has_many :abilities
  has_many :skills, through: :abilities
  mount_uploader :avatar, AvatarUploader

  JOB_TYPES = ["Full-time", "Part-time", "Contract", "Freelance"]
  

  def self.search(params)
    jobs = Job.where("
      jobs.title LIKE :search OR description LIKE :search", search: "%#{params[:search]}%"
    ) if params[:search].present?
    jobs
  end
end