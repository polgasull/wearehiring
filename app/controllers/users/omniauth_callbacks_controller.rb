class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController  
  def linkedin
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      @job = Job.find(request.env['omniauth.params']['job_id'])
      create_inscription(@job, @user)
      set_flash_message(:notice, :success, :kind => 'Linkedin') if is_navigational_format?
    else
      session['devise.linkedin_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.env['omniauth.origin']
      request.env['omniauth.origin']
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def create_inscription(job, user)
    @inscription = Inscription.create(job_id: job.id, user_id: user.id)
    if @inscription.save
      @inscription.user.update(accepted_terms: true) unless @inscription.user.accepted_terms
      flash[:notice] = t('inscription_created')
      ModelMailer.new_candidate(user, job).deliver unless Rails.env.test?
      ModelMailer.new_inscription(user, job).deliver unless Rails.env.test?
    else 
      flash[:alert] = t('already_inscribed')
    end
  end

end