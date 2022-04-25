class CompaniesRegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  layout 'new_company_registration'

  def new
    super
  end

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

  def company_type
    UserType.where(internal_name: 'company').first.id
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id, :accepted_terms, :job_id, :phone]
    )
  end
end