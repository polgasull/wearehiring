class ApplicationController < ActionController::Base
  include ResponseHelper
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def validate_is_candidate!
    redirect_to root_path if current_user.user_type.name != 'Candidate'
  end

  def validate_is_company!
    redirect_to root_path if current_user.user_type.name != 'Company'
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
