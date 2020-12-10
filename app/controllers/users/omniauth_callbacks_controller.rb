class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def linkedin
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      if request.env['omniauth.params']['job_id']
        @job = Job.find(request.env['omniauth.params']['job_id'])
        create_inscription(@job, @user)
      end
      set_flash_message(:notice, :success, :kind => 'Linkedin') if is_navigational_format?
    else
      session['devise.linkedin_data'] = request.env['omniauth.auth']
      redirect_to root_url
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.env['omniauth.origin'] && request.env['omniauth.params']['job_id']
      request.env['omniauth.origin']
    else 
      root_path
    end 
  end

  def failure
    redirect_to root_path
  end

  private

  def create_inscription(job, user)
    @inscription = Inscription.create(job_id: job.id, user_id: user.id)
    if @inscription.save
      @inscription.user.update(accepted_terms: true) unless @inscription.user.accepted_terms?
      flash[:notice] = t('inscriptions.messages.inscription_created')
      ModelMailer.new_candidate(user, job).deliver if Rails.env.production?
      ModelMailer.successfully_inscribed(user, job).deliver if Rails.env.production?
    else 
      flash[:alert] = t('already_inscribed')
    end
  end

end