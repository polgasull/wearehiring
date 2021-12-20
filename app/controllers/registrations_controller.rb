# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController

  def create
    super do
      if has_duplicate_email?
        flash[:alert] = signup_taken_message
        redirect_back(fallback_location: root_path) and return
      end
    end
  end

  private 

  def has_duplicate_email?
    return false unless resource.errors.has_key?(:email)
    resource.errors.details[:email].any? do |hash|
      hash[:error] == :taken
    end
  end

  def signup_taken_message
    t('devise.failure.taken')
  end
end
