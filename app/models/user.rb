class User < ApplicationRecord
  extend FilterBy
  include Users::UserScopes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable, :confirmable, :omniauthable, :omniauth_providers => [:linkedin]

  belongs_to :user_type
  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :jobs
  has_many :inscriptions
  mount_uploader :picture_url, AvatarUploader

  attr_accessor :company

  %w[candidate company admin].each do |user_type_name|
    define_method "is_#{user_type_name}?" do
      user_type&.internal_name == user_type_name
    end
  end

  def is_ambassador_company?
    ambassador == true
  end

  def self.candidates
    joins(:user_type).where(user_types: { internal_name: 'candidate' })
  end

  def self.companies
    joins(:user_type).where(user_types: { internal_name: 'company' })
  end

  def is_already_inscribed(job)
    inscriptions.any? {|u| u[:job_id] == job.id}
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.linkedin_data'] && session['devise.linkedin_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.user_type_id = UserType.where(internal_name: 'candidate').first.id
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name # assuming the user model has a name
    user.last_name = auth.info.last_name
    user.accepted_terms = true
    end
  end

  def total_inscriptions_sum(jobs)
    inscriptions = []

    jobs.each do |job|
      inscriptions << job.inscriptions.count
    end
    
    inscriptions.inject(0){|sum,x| sum + x }
  end

  def last_inscribeds(jobs)
    inscriptions = []

    jobs.where(job_price_id: [1,2]).each do |job|
      job.inscriptions.map{ |i| inscriptions << i }
    end

    inscriptions
  end

  def free_jobs_active
    jobs.active.where(job_price_id: 3)
  end

  def after_confirmation
    if self.is_company?
      ModelMailer.welcome_company(self).deliver_later
      DiscordService.new.company_signup_alert_webhook(self)
    else
      ModelMailer.welcome_candidate(self).deliver_later
      DiscordService.new.candidate_signup_alert_webhook(self)
    end
  end

  def self.update_residence_info
    User.where(resident_country: [nil, ""]).last(25).each do |user|
      begin
        location_info = Geocoder.search(user.last_sign_in_ip).first
        
        user.transaction do
          user.update!(
            resident_city: location_info.city,
            resident_state: location_info.state,
            resident_country: location_info.country,
            resident_country_code: location_info.country_code,
            resident_postal_code: location_info.postal_code
          )
        end if !added_by_company
      rescue Geocoder::OverQueryLimitError => e
        sleep(5)
    
        Rails.logger.error("Geocoder request limit exceeded: #{e.message}")
    
        user.update!(
          resident_city: '',
          resident_state: '',
          resident_country: '',
          resident_country_code: '',
          resident_postal_code: ''
        )
      else
        Rails.logger.info("User resident information updated successfully.")
      end
    end
  end

  def self.update_confirmed_at
    User.all.each do |user|
      user.update(confirmed_at: DateTime.now)
    end
  end
end
