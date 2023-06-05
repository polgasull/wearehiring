class ModelMailer < ApplicationMailer
  default :from => 'Wearehiring.io <hello@wearehiring.io>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_user_notification.subject
  #

  def new_job(user, job)
    @user = user
    @job = job

    attachments.inline["WEH_LOGO_PNG_vertical_red.png"] = File.read("#{Rails.root}/app/assets/images/WEH_LOGO_PNG_vertical_red.png")
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
    attachments.inline["WEH_LOGO_PNG_vertical_red.png"] = File.read("#{Rails.root}/app/assets/images/WEH_LOGO_PNG_vertical_red.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @job.user.email,
      :subject => t('notifiers.new_candidate_subject', job_title: @job.title)
    )  
  end

  # Deactivated: this was sent to free jobs.
  def new_candidate_hidden(job)
    @job = job

    attachments.inline["user_circle.png"] = File.read("#{Rails.root}/app/assets/images/user_circle.png")
    attachments.inline['WEH_LOGO_PNG_vertical_red.png'] = File.read("#{Rails.root}/app/assets/images/WEH_LOGO_PNG_vertical_red.png")
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
    attachments.inline["discord.png"] = File.read("#{Rails.root}/app/assets/images/discord.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => @user.email,
      :subject => t('notifiers.applied_to_title', job_title: @job.title, job_location: @job.location)
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
    attachments.inline["discord.png"] = File.read("#{Rails.root}/app/assets/images/discord.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail(
      :to => @inscription.user.email,
      :subject => t('notifiers.status_update_title', job_title: @job.title, inscription_status: t("inscriptions.#{@inscription.status}"))
    )
  end

  def welcome_company(user)
    @user = user

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    mail( 
      :to => user.email,
      :subject => t('notifiers.welcome_wah')
    )  
  end

  def welcome_candidate(user)
    @user = user

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")
    attachments.inline["discord.png"] = File.read("#{Rails.root}/app/assets/images/discord.png")
    mail( 
      :to => user.email,
      :subject => t('notifiers.welcome_wah') 
    )  
  end

  def upgrade_job_proposal(job)
    @user = job.user
    @job = job

    attachments.inline["logo_black.png"] = File.read("#{Rails.root}/app/assets/images/logo_black.png")
    attachments.inline["twitter.png"] = File.read("#{Rails.root}/app/assets/images/twitter.png")
    attachments.inline["linkedin.png"] = File.read("#{Rails.root}/app/assets/images/linkedin.png")

    mail(
      :to => @user.email,
      :subject => 'Has alcanzado el máximo de candidatos'
    )
  end
end
