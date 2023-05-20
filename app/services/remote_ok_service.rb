# frozen_string_literal: true

class RemoteOkService

  def initialize
    @base_url = "https://remoteok.com/api"
    @default_logo = "https://www.wearehiring.io/assets/wah_red_logo-098ea70391fd60cd0aa5f8d4ba6636945bed44ca6e8ef44c3311dc398832aa0e.png"
  end

  def fetch_jobs
    conn = Faraday.new(
      :url => @base_url,
      headers: {'Content-Type' => 'application/json'}
      )
    
    response = conn.get(@base_url)
    response.body
  end

  def create_jobs(results)
    results.each_with_index do |result, index|
      @job = Job.where(url: result["slug"]).first_or_create do |job|
        # create job if it does not exist and assign other attributes
        job.title = result["position"]
        job.description = result["description"]
        job.apply_url = result["apply_url"]
        job.location = result["location"]
        job.job_author = result["company"]
        job.created_at = Job.active.first.created_at - (index + 2).hours
        job.updated_at = result["date"]
        job.salary_from = result["salary_min"].nil? ? 0 : result["salary_min"]
        job.salary_to = result["salary_max"].nil? ? 0 : result["salary_max"]
        job.partner_id = Partner.find_by(name: "Remote Ok").id
        job.remote_ok = true
        job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
        job.expiry_date = DateTime.now() + 90.days
        job.open = true
        job.job_price_id = JobPrice.find_by(internal_name: 'free').id
        job.job_type_id = JobType.find_by(internal_name: 'full_time').id
        job.level_id = Level.find_by(internal_name: 'intermediate').id
        job.category_id = Category.find_by(internal_name: 'web_development').id
        job.remote_avatar_url = result["logo"].strip.end_with?("peg") ? @default_logo : result["logo"].strip
        job.url = result["slug"]
        job.user_id = User.where(user_type_id: 3).first.id
      end
      result["tags"].each do |tag|
        JobSkill.find_or_create_by(
          skill_id: Skill.find_or_create_by(internal_name: tag, name: tag&.capitalize).id,
          job_id: @job.id
        )
      end if result["tags"].present?
    end
  end
end
