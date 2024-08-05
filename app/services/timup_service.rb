# frozen_string_literal: true

class TimupService

  def initialize
    @base_url = "https://api.manatal.com/open/v3/career-page/timup/jobs/?page_size=300"
    @default_logo = "https://timup.es/wp-content/uploads/2022/07/cropped-favicon.png"
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
      job_id = result["id"].to_s
      reference = "wah#{DateTime.now.year}#{job_id}"
      @job = Job.where(reference: reference).first_or_create do |job|
        # create job if it does not exist and assign other attributes
        job.title = result["position_name"]
        job.description = result["description"]
        job.apply_url = "https://timup.es/ofertas/#" + job_id
        job.location = result["city"].present? ? result["city"] : "Remote"
        job.job_author = "Timup Select Wisely"
        job.salary_from = 0
        job.salary_to = 0
        job.partner_id = Partner.find_by(name: "Timup").id
        job.remote_ok = result["is_remote"].nil? ? false : true
        job.reference = reference
        job.expiry_date = DateTime.now() + 30.days
        job.open = true
        job.job_price_id = JobPrice.find_by(internal_name: 'free').id
        job.job_type_id = JobType.find_by(internal_name: 'full_time').id
        job.level_id = Level.find_by(internal_name: 'intermediate').id
        job.category_id = Category.find_by(internal_name: 'marketing').id
        job.remote_avatar_url = @default_logo
        job.user_id = User.where(user_type_id: 3).first.id
      end
      JobSkill.find_or_create_by(
        skill_id: Skill.find_or_create_by(internal_name: result['address'].downcase, name: result['address']).id,
        job_id: @job.id
      )
    end
  end
end
