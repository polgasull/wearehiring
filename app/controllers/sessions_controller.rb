# frozen_string_literal: true

class SessionsController < Devise::RegistrationsController

  def create
    if User.find_by_email(params[:user][:email]).present?
      if User.find_by_email(params[:user][:email]).try(:confirmed_at).present?
        super
      else
        redirect_back_response(t('devise.failure.unconfirmed'), false)
      end
    else
      redirect_back_response(t('devise.failure.user_not_found'), false)
    end
  end
end
