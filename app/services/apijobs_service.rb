# frozen_string_literal: true

class ApijobsService

  def initialize
    @base_url = "https://api.apijobs.dev/v1"
    @default_logo = "https://www.wearehiring.io/assets/wah_red_logo-098ea70391fd60cd0aa5f8d4ba6636945bed44ca6e8ef44c3311dc398832aa0e.png"
  end

  def fetch_jobs
    conn = Faraday.new(
      :url => @base_url,
      headers: {
        'apikey' => ENV['APIJOBS_API_KEY'],
        'Content-Type' => 'application/json'
        }
      )
    
    query = "Software data product developer frontend backend design ux ui"
    response = conn.post("/job/search", { q: query}.to_json)
    response.body
  end

  def create_jobs(results)
    results.each_with_index do |result, index|
      next unless result['hiringOrganizationLogo'].present?

      @job = Job.where(reference: "wah#{DateTime.now.year}#{result["id"]}").first_or_create do |job|
        # create job if it does not exist and assign other attributes
        job.title = result["title"]
        job.description = result["description"]
        job.apply_url = result["url"]
        job.location = result["city"].present? ? result["city"] : "Remote"
        job.job_author = result["hiringOrganizationName"].present? ? result["hiringOrganizationName"] : result["websiteName"]
        job.created_at = Time.parse(result['created_at'])
        job.updated_at = Time.parse(result['created_at'])
        job.salary_from = result["baseSalaryValueMinValue"].present? ? result["baseSalaryValueMinValue"] : 0
        job.salary_to = result["baseSalaryValueMaxValue"].present? ? result["baseSalaryValueMaxValue"] : 0
        job.partner_id = Partner.find_by(name: "ApiJobs").id
        job.remote_ok = result["city"].present? ? false : true
        job.reference = "wah#{DateTime.now.year}#{result["id"]}"
        job.expiry_date = DateTime.now() + 30.days
        job.open = true
        job.job_price_id = JobPrice.find_by(internal_name: 'free').id
        job.job_type_id = JobType.find_by(internal_name: 'full_time').id
        job.level_id = Level.find_by(internal_name: 'intermediate').id
        job.category_id = Category.find_by(internal_name: 'web_development').id
        job.remote_avatar_url = result["hiringOrganizationLogo"]
        job.url = result["websiteUrl"]
        job.user_id = User.where(user_type_id: 3).first.id
      end
      if result["skills"].present?
        skills_array = result["skills"].split(',')
        skills_array.each do |skill_name|
          skill = Skill.find_or_create_by(internal_name: skill_name.strip, name: skill_name.strip.capitalize)
          JobSkill.find_or_create_by(skill_id: skill.id, job_id: @job.id)
        end
      end
    end
  end
end
