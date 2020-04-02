class Job < ApplicationRecord
  extend Filter

  belongs_to :user
  belongs_to :category
  has_many :abilities
  has_many :skills, through: :abilities
  mount_uploader :avatar, AvatarUploader

  geocoded_by :location
  after_validation :geocode

  JOB_TYPES = ["Full-time", "Part-time", "Contract", "Freelance"]
  
  scope :search_for, -> (query) { 
    where('LOWER(jobs.title) LIKE :query OR 
          LOWER(jobs.job_author) LIKE :query OR 
          LOWER(jobs.description) LIKE :query OR
          LOWER(jobs.location) LIKE :query', 
          query: "%#{query.downcase}%") 
  }

  scope :by_category, -> (category) {
    joins(:category).
    where('categories.id = ?', category)
  }

end