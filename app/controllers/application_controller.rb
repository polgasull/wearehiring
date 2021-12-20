class ApplicationController < ActionController::Base
  include ResponseHelper
  include InscriptionsHelper
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # def validate_is_candidate!
  # def validate_is_company!
  # def validate_is_admin!
  # def validate_is_ambassador!
  %w[candidate company admin ambassador].each do |user_type_name|
    define_method "validate_is_#{user_type_name}!" do
      redirect_to root_path unless current_user&.send("is_#{user_type_name}?")
    end
  end

  def validate_is_candidate_or_admin!
    redirect_to root_path unless current_user.is_company? && current_user.is_admin?
  end

  def validate_is_company_or_ambassador!
    redirect_to root_path unless current_user.is_company? || current_user.is_ambassador?
  end

  def validate_is_recruiter!
    redirect_to root_path unless current_user.is_company? && current_user.is_ambassador? && current_user.is_admin?
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
      Inscription.create(job_id: params[:job_id], user_id: current_user.id)
      job_path(params[:job_id])
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id, :accepted_terms, :job_id, :phone]
    )
    devise_parameter_sanitizer.permit(
      :account_update, 
      keys: [:name, :last_name, :picture_url, :location, :profile_url, :user_type_id, :accepted_terms, :phone]
    )
  end
end
