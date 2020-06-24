class ModelMailer < ApplicationMailer
  default :from => 'hello@wearehiring.io'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_user_notification.subject
  #

  def new_job(user, job)
    @user = user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @user.email,
      :subject => 'Congrats! Nuevo Job Publicado! 🥳' 
    )
  end

  def new_candidate(user, job)
    @user = user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => job.user.email,
      :subject => 'Tienes un nuevo candidato ✅' 
    )  
  end
  
  def new_inscription(user, job)
    @user = user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => user.email,
      :subject => 'Has solicitado el Job correctamente 💪' 
    )  
  end

  def welcome_email(user)
    @user = user

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => user.email,
      :subject => 'Bienvenido a We Are Hiring 🚀' 
    )  
  end
end
