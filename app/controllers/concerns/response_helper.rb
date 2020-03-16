# frozen_string_literal: true

module ResponseHelper
  def order_is_paid_response
    flash[:alert] = t('order_has_been_paid')
    redirect_to root_path
  end

  def order_not_found_response
    flash[:alert] = t('order_not_found')
    redirect_back(fallback_location: root_path)
  end

  def upload_payment_fail_response
    flash[:alert] = t('upload_payment_bad')
    redirect_to settings_path(payment_method: true)
  end

  def user_is_not_admin_to_change_payment_method
    flash[:alert] = t('user_is_not_admin_to_change_payment_method')
    redirect_back(fallback_location: root_path)
  end

  def planning_not_assignment_response
    flash[:alert] = t('assignment_not_found')
    redirect_to root_path
  end

  def planning_updated_response
    flash[:notice] = t('order_updated_ok')
  end

  def not_permissions_response
    flash[:alert] = t('do_not_have_permissions')
    redirect_back(fallback_location: root_path)
  end

  def assignment_is_already_accepted
    flash[:alert] = t('no_cargo_available')
    redirect_back(fallback_location: root_path)
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
