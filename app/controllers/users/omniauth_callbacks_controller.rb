# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def linkedin
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => 'Linkedin') if is_navigational_format?
    else
      session['devise.linkedin_data'] = request.env['omniauth.auth']
      redirect_to root_url
    end
  end

  def failure
    redirect_to root_path
  end
end
