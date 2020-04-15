class ApplicationController < ActionController::Base
  include ResponseHelper
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name, :picture_url, :location, :profile_url])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :last_name, :picture_url, :location, :profile_url])
    end
end
