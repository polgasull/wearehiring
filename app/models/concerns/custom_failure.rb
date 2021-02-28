class CustomFailure < Devise::FailureApp
  def redirect_url
    root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      flash[:alert] = i18n_message
      redirect_back(fallback_location: root_path)
    end
  end

  def i18n_message
    I18n.t('devise.failure.wrong_email_or_password') # you might go for something more elaborate here
  end
end