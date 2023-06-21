# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ResponseHelper
  before_action :set_locale
  protect_from_forgery with: :exception

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    if request.path == '/' && I18n.locale == :es
      redirect_to root_path(locale: I18n.locale.to_s)
    end
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
    current_user.transaction do
      current_user.update!(
        resident_city: Geocoder.search(current_user.current_sign_in_ip).first.city,
        resident_state: Geocoder.search(current_user.current_sign_in_ip).first.state,
        resident_country: Geocoder.search(current_user.current_sign_in_ip).first.country,
        resident_country_code: Geocoder.search(current_user.current_sign_in_ip).first.country_code,
        resident_postal_code: Geocoder.search(current_user.current_sign_in_ip).first.postal_code
      )
    end

    root_path
  end

  private

  def extract_locale
    parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    available_locales = I18n.available_locales.map(&:to_s)
    parsed_locale && available_locales.include?(parsed_locale) ? parsed_locale.to_sym : nil
  end
end
