# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  invisible_captcha only: [:create]

  def create
    super do
      if has_duplicate_email?
        flash[:alert] = signup_taken_message
        redirect_back(fallback_location: root_path) and return
      end
    end
  end

  def update
    super
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

  def candidate_type
    UserType.where(internal_name: 'candidate').first.id
  end

  def after_inactive_sign_up_path_for(resource)
    :sign_up_thanks
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id, :accepted_terms, :job_id, :phone]
    )
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id, :accepted_terms, :job_id, :phone]
    )
  end
end
