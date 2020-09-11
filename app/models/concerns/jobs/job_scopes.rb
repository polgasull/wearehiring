# frozen_string_literal: true

module Jobs
  module JobScopes
    extend ActiveSupport::Concern

    included do
      scope :search_for, -> (query) { 
        where('LOWER(jobs.title) LIKE :query OR 
              LOWER(jobs.job_author) LIKE :query OR 
              LOWER(jobs.description) LIKE :query OR
              LOWER(jobs.location) LIKE :query', 
              query: "%#{query.downcase}%") 
      }
    
      scope :search_my_jobs, -> (query) { 
        where('LOWER(jobs.title) LIKE :query OR 
              LOWER(jobs.reference) LIKE :query OR 
              LOWER(jobs.job_author) LIKE :query OR 
              LOWER(jobs.description) LIKE :query OR
              LOWER(jobs.location) LIKE :query', 
              query: "%#{query.downcase}%") 
      }
    
      scope :by_category, -> (category) {
        joins(:category).
        where('categories.id = ?', category)
      }
    
      scope :by_job_type, -> (job_type) {
        joins(:job_type).
        where('job_types.id = ?', job_type)
      }
    
      scope :by_level, -> (level) {
        joins(:level).
        where('levels.id = ?', level)
      }
    
      scope :my_jobs, -> (current_user_id) {
        where(user_id: current_user_id)
      }
    
      scope :is_remote, -> (value) {
        where(remote_ok: value)
      }
    
      scope :same_category, -> (job) {
        where('jobs.category_id = ? AND jobs.id != ?', job.category_id, job.id)
      }
    end
  end
end