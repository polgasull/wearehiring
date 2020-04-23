class ModelMailer < ApplicationMailer
  default :from => 'wearehiringstartup@gmail.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_user_notification.subject
  #
  def new_user_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def new_job(user)
    @user = user

    mail( 
      :to => @user.email,
      :subject => 'You published a new Job!' 
    )
  end

  def new_inscription(user)
    @user = user

    mail( 
      :to => @user.email,
      :subject => 'You received a new inscription!' 
    )  
  end
end
