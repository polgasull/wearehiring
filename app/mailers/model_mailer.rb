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

  def new_job(user, job)
    @user = user
    @job = job

    mail( 
      :to => @user.email,
      :subject => 'You published a new Job!' 
    )
  end

  def new_inscription(user, job)
    @user = user

    mail( 
      :to => job.user.email,
      :subject => 'You received a new inscription!' 
    )  
  end
end
