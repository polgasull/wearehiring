class Post < ApplicationRecord
  extend FriendlyId

  has_many :comments, dependent: :destroy 

  mount_uploader :image, AvatarUploader
  friendly_id :custom_url, use: [:slugged]

  def should_generate_new_friendly_id?
    custom_url_changed? || super
  end
end