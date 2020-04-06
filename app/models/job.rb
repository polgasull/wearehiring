class Job < ApplicationRecord
  extend Filter

  belongs_to :user
  belongs_to :category
  belongs_to :job_type
  has_many :taggings
  has_many :tags, through: :taggings
  mount_uploader :avatar, AvatarUploader

  geocoded_by :location
  after_validation :geocode
  
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

  scope :by_job_type, -> (job_type) {
    joins(:job_type).
    where('job_types.id = ?', job_type)
  }

  scope :my_jobs, -> (current_user_id) {
    where(user_id: current_user_id)
  }

  scope :is_remote, -> (value) {
    where(remote_ok: value)
  }

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{ |s| s.strip.downcase }.uniq
    new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end

  def tag_list 
    self.tags.collect do |tag| 
      tag.name
    end.join(", ")
  end

  def self.order_list(sort_order)
    if sort_order == "newest" || sort_order.blank?
      order(created_at: :desc)
    elsif sort_order == "by_title"
      order(title: :asc)
    else 
      order(created_at: :asc)
    end
  end
end