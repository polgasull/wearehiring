class Job < ApplicationRecord
  extend Filter

  belongs_to :user
  belongs_to :category
  has_many :abilities
  has_many :skills, through: :abilities
  mount_uploader :avatar, AvatarUploader

  JOB_TYPES = ["Full-time", "Part-time", "Contract", "Freelance"]
  
  scope :search, -> (query) { 
    where('LOWER(jobs.title) LIKE :query OR 
          LOWER(jobs.job_author) LIKE :query or 
          LOWER(jobs.description) LIKE :query', 
          query: "%#{query.downcase}%") 
  }

end