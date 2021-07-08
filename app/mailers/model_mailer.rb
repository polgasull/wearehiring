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
      :subject => "Tu oferta #{@job.title} ha sido publicada! 🚀"
    )
  end

  def new_candidate(user, job)
    @user = user
    @job = job

    attachments.inline["user_circle.png"] = File.read("#{Rails.root}/app/assets/images/user_circle.png")
    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @job.user.email,
      :subject => "✅ Nuevo candidato para #{@job.title}" 
    )  
  end
  
  def successfully_inscribed(user, job)
    @user = user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @user.email,
      :subject => "Has aplicado para #{@job.title} en #{job.remote_ok? ? '(Remoto)' : job.location}"
    )  
  end

  def new_job_scrapping(user, job)
    @user = user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @job.external_mail,
      :subject => "¡Tu oferta #{@job.title} ha sido publicada! 🚀"
    )
  end

  def update_inscription_status(inscription, job)
    @inscription = inscription
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail(
      :to => @inscription.user.email,
      :bcc => 'pol@wearehiring.io',
      :subject => "Tu estado en el proceso de #{@job.title} ha cambiado a #{@inscription.status}"
    )
  end
end
