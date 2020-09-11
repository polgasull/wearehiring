# frozen_string_literal: true

module Users
  module UserScopes
    extend ActiveSupport::Concern

    included do
      scope :search_users, -> (query) { 
        where('LOWER(users.name) LIKE :query OR 
              LOWER(users.email) LIKE :query OR 
              LOWER(users.current_position) LIKE :query', 
              query: "%#{query.downcase}%") 
      }
    
      scope :by_user_type, -> (user_type) {
        joins(:user_type).
        where('user_types.id = ?', user_type)
      }
    end
  end
end