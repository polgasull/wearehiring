class ApplicationController < ActionController::Base
  include ResponseHelper
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # def validate_is_candidate!
  # def validate_is_company!
  # def validate_is_admin!
  %w[candidate company admin ambassador].each do |user_type_name|
    define_method "validate_is_#{user_type_name}!" do
      redirect_to root_path unless current_user&.send("is_#{user_type_name}?")
    end
  end

  def validate_is_candidate_or_admin!
    redirect_to root_path if !current_user.is_company? && !current_user.is_admin?
  end

  def validate_is_company_or_ambassador!
    redirect_to root_path if !current_user.is_company? && !current_user.is_ambassador?
  end

  def validate_is_recruiter!
    redirect_to root_path if current_user.is_candidate?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id]
    )
    devise_parameter_sanitizer.permit(
      :account_update, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id]
    )
  end
end
