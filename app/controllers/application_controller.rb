# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ResponseHelper
  before_action :set_locale
  protect_from_forgery with: :exception

  ALLOWED_LOCALES = %w( en es ).freeze
  DEFAULT_LOCALE = 'en'.freeze

  def set_locale
    I18n.locale = extract_locale_from_headers
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

  def validate_is_company!
    redirect_to root_path unless current_user.is_company?
  end

  def validate_is_recruiter!
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
    if params[:job_id].present?
      find_job(params[:job_id])
      Inscription.create(job_id: @job.id, user_id: current_user.id)
      current_user.transaction do
        current_user.update!(
          resident_city: Geocoder.search(current_user.current_sign_in_ip).first.city,
          resident_state: Geocoder.search(current_user.current_sign_in_ip).first.state,
          resident_country: Geocoder.search(current_user.current_sign_in_ip).first.country,
          resident_country_code: Geocoder.search(current_user.current_sign_in_ip).first.country_code,
          resident_postal_code: Geocoder.search(current_user.current_sign_in_ip).first.postal_code
        )
      end
      DiscordService.new.inscription_alert_webhook(current_user, @job, false)
      job_path(@job.id)
    else
      root_path
    end
  end

  private

  def find_job(job_id)
    @job = Job.find(job_id)

    rescue ActiveRecord::RecordNotFound
      redirect_to not_found_url
  end

  def extract_locale_from_headers
    browser_locale = request.env['HTTP_ACCEPT_LANGUAGE'].present? ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : DEFAULT_LOCALE
    if ALLOWED_LOCALES.include?(browser_locale)
      browser_locale
    else
      DEFAULT_LOCALE
    end
  end
end
