# frozen_string_literal: true

class UserType < ApplicationRecord
  has_many :users

  validates :internal_name, :name, presence: true
  validates :internal_name, uniqueness: true
end