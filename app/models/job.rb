class Job < ApplicationRecord
  extend Filter

  belongs_to :user
  belongs_to :category
  has_many :abilities
  has_many :skills, through: :abilities
  mount_uploader :avatar, AvatarUploader

  JOB_TYPES = ["Full-time", "Part-time", "Contract", "Freelance"]
  
  scope :search_for, -> (query) { 
    where('LOWER(jobs.title) LIKE :query OR 
          LOWER(jobs.job_author) LIKE :query or 
          LOWER(jobs.location) LIKE :query', 
          query: "%#{query.downcase}%") 
  }

  scope :by_job_type, -> (query) { 
    where('LOWER(jobs.job_type) LIKE :query', 
          query: "%#{query.downcase}%") 
  }

  scope :search, -> (param={}) {
    relation = all
    relation = relation.by_job_type(param[:by_job_type]) if param[:by_job_type].present?
    relation = relation.search_for(param[:search_for]) if param[:search_for].present?
    relation
  }
  
end