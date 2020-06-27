class Post < ApplicationRecord
  has_many :comments, dependent: :destroy 

  mount_uploader :image, AvatarUploader
end