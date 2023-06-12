class Job < ApplicationRecord
  extend FilterBy
  extend FriendlyId
  include Jobs::JobScopes
  is_impressionable

  belongs_to :user
  belongs_to :category
  belongs_to :job_type
  belongs_to :level
  belongs_to :partner, required: false
  belongs_to :job_price
  has_many :job_skills
  has_many :skills, through: :job_skills
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :inscriptions, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :reference, uniqueness: true

  geocoded_by :location
  after_validation :geocode
  friendly_id :title_location_author_reference, use: [:slugged, :history, :finders]

  def title_location_author_reference
    "#{title} #{location} #{job_author} #{reference}"
  end

  scope :active, -> { where(open: true) }
  scope :inactive, -> { where(open: false) }

  def is_expired?
    return false if expiry_date.nil?

    expiry_date < Date.today
  end

  def self.close_expired_jobs
    active = Job.active
    active.each do |job|
      if job.is_expired?
        job.update(
          open: false,
        )
      end
    end
  end

  def self.send_upgrade_job_email_proposal
    return false unless Date.today.tuesday?

    free_jobs = Job.active.where(job_price_id: 3)
    free_jobs.each do |job|
      if (job.inscriptions.count >= 15)
        ModelMailer.upgrade_job_proposal(job).deliver_later
      end
    end
  end

  def user_owner_or_admin(current_user)
    user_id == current_user&.id || current_user&.is_admin?
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{ |s| s.strip.downcase }.uniq
    new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end

  def tag_list 
    self.tags.collect do |tag| 
      tag.name
    end.join(", ")
  end

  def self.order_list(sort_order)
    if sort_order == "newest" || sort_order.blank?
      order(created_at: :desc)
    elsif sort_order == "by_title"
      order(title: :asc)
    else 
      order(created_at: :asc)
    end
  end

  def show_matching_candidates(job_skills)
    candidates = []

    job_skills.each do |skill|
      skill.users.where(visible: true)
                 .where(resident_country_code: 'ES')
                 .where.not(current_position: [nil, ""])
                 .where(experience: ["2-6 años", "6-10 años", "+10 años"]).each do |user|
        candidates << user if candidates.exclude?(user)
      end
    end
    
    return candidates
  end

  def show_filtered_matching_candidates(job_skills, search_params)
    candidates = []
    
    job_skills.each do |skill|
      skill.users.search_users(search_params).where(visible: true)
                                             .where(resident_country_code: 'ES')
                                             .where.not(current_position: [nil, ""])
                                             .where(experience: ["2-6 años", "6-10 años", "+10 años"]).each do |user|
        candidates << user if candidates.exclude?(user)
      end
    end
    
    return candidates
  end

  %w[free basic pro].each do |job_type_name|
    define_method "is_#{job_type_name}_price?" do
      job_price&.internal_name == job_type_name
    end
  end

  def self.create_jobs_from_talent_hackers
    talent_hackers_jobs = JSON.parse(TalentHackersService.new.fetch_jobs).with_indifferent_access
    results = talent_hackers_jobs[:results]
    TalentHackersService.new.create_jobs(results)
  end

  def self.create_jobs_from_remote_ok
    remote_ok_jobs = JSON.parse(RemoteOkService.new.fetch_jobs)
    results = remote_ok_jobs
    RemoteOkService.new.create_jobs(results)
  end

  def self.send_random_active_job_tweet_notification
    job = Job.active.where.not(salary_to: [nil, 0]).sample
    TwitterService.new.send_job_detail_tweet(job)
  end
end
