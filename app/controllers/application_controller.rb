# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ResponseHelper
  before_action :set_locale
  before_action :set_currency
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
    begin
      location_info = Geocoder.search(current_user.current_sign_in_ip).first
  
      current_user.transaction do
        current_user.update!(
          resident_city: location_info.city,
          resident_state: location_info.state,
          resident_country: location_info.country,
          resident_country_code: location_info.country_code,
          resident_postal_code: location_info.postal_code
        )
      end
    rescue Geocoder::OverQueryLimitError => e
      sleep(5)
  
      Rails.logger.error("Geocoder request limit exceeded: #{e.message}")
    else
      Rails.logger.info("User resident information updated successfully.")
    end
  
    root_path
  end

  def set_currency
    user_location = request.location
    @user_country_code = user_location&.country_code || 'EU'
  end

  private

  def extract_locale
    parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    available_locales = I18n.available_locales.map(&:to_s)
    parsed_locale && available_locales.include?(parsed_locale) ? parsed_locale.to_sym : nil
  end
end
