# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ResponseHelper
  before_action :set_locale
  before_action :set_currency
  protect_from_forgery with: :exception

  def set_locale
    I18n.locale = I18n.default_locale
  end

  # def validate_is_candidate!
  # def validate_is_company!
  # def validate_is_admin!
  %w[candidate company admin].each do |user_type_name|
    define_method "validate_is_#{user_type_name}!" do
      redirect_to root_path unless current_user&.send("is_#{user_type_name}?")
    end
  end

  def validate_is_candidate_or_admin!
    redirect_to root_path unless current_user.is_company? && current_user.is_admin?
  end

  def not_found
    render status: 404
  end

  def unacceptable
    render status: 422
  end

  def internal_server_error
    render status: 500
  end

  def after_sign_in_path_for(resource)  
    root_path
  end

  def set_currency
    user_location = request.location
    @user_country_code = user_location&.country_code || 'EU'
  end
end
