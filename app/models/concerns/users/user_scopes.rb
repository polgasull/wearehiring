# frozen_string_literal: true

module Users
  module UserScopes
    extend ActiveSupport::Concern

    included do
      scope :search_users, -> (query) {
        left_outer_joins(:skills).
        where('LOWER(users.name) LIKE :query OR 
              LOWER(users.email) LIKE :query OR 
              LOWER(users.current_position) LIKE :query OR
              LOWER(users.experience) LIKE :query OR
              LOWER(skills.name) LIKE :query OR
              LOWER(users.location) LIKE :query OR
              LOWER(users.resident_country_code) LIKE :query',
              query: "%#{query.downcase}%")
      }
    
      scope :by_user_type, -> (user_type) {
        joins(:user_type).
        where('user_types.id = ?', user_type)
      }

      scope :without_skills, -> () {
        left_outer_joins(:user_skills).where(user_skills: {user_id: nil})
      }
    end
  end
end