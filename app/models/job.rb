class Job < ApplicationRecord
  extend Filter
  extend FriendlyId
  include Jobs::JobScopes

  belongs_to :user
  belongs_to :category
  belongs_to :job_type
  belongs_to :level
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :inscriptions, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  validates :reference, uniqueness: true

  geocoded_by :location
  after_validation :geocode
  friendly_id :title_location_author_reference, use: :slugged

  def title_location_author_reference
    "Empleo de #{title} en #{location} #{job_author} #{reference}"
  end

  def self.not_expired
    where('expiry_date >= ?', Date.today)
  end

  def self.expired
    where('expiry_date < ?', Date.today)
  end

  def is_active?
    expiry_date >= Date.today
  end

  def is_expired?
    expiry_date < Date.today
  end

  def user_owner_or_admin(current_user)
    user_id == current_user&.id || current_user&.is_admin?
  end

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