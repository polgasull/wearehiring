class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable, :omniauth_providers => [:linkedin]

  belongs_to :user_type
  has_many :jobs
  has_many :inscriptions
  after_create :send_welcome_mail

  %w[candidate company].each do |user_type_name|
    define_method "is_#{user_type_name}?" do
      user_type&.internal_name == user_type_name
    end
  end

  def my_jobs
    Job.where(user_id: id)
  end

  def my_inscriptions
    Inscription.where(user_id: id)
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
    user.picture_url = auth.info&.picture_url
    end
  end

  def send_welcome_mail
    if self.is_company?
      ModelMailer.welcome_email(self).deliver
    end
  end
end
