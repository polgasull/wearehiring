# frozen_string_literal: true

module ResponseHelper
  def you_must_sign_in_as_company
    flash[:notice] = t('devise.failure.unauthenticated')
    redirect_to new_user_session_path(:company => "true")
  end

  def redirect_back_response(message, is_success = true)
    is_success ? flash[:notice] = message : flash[:alert] = message
    redirect_back(fallback_location: root_path)
  end

  def redirect_to_response(message, root, is_success = true)
    is_success ? flash[:notice] = message : flash[:alert] = message
    redirect_to root
  end
end
