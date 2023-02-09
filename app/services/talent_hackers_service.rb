# frozen_string_literal: true

class TalentHackersService
  TOKEN = ENV['TALENT_HACKERS_TOKEN']

  def initialize
    @base_url = "https://talenthackers.net/api/spot-search/"
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
    results.take.each_with_index do |result, index|
      Job.where(url: result["slug"]).first_or_create do |job|
        # create job if it does not exist and assign other attributes
        job.title = result["title"]
        job.description = result["description"]
        job.apply_url = "https://talenthackers.net/spots/#{result["area"]}/#{result["slug"]}?rid=#{TOKEN}"
        job.location = result["office_city"]
        job.job_author = "Talent Hackers"
        job.created_at = Job.active.first.created_at - (index + 2).hours
        job.updated_at = result["updated"]
        job.salary_from = result["salary"].nil? ? 0 : result["salary"]["salary_min"]
        job.salary_to = result["salary"].nil? ? 0 : result["salary"]["salary_max"]
        job.partner_id = Partner.find_by(name: "Talent Hackers").id
        job.remote_ok = result["full_remote"]
        job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
        job.expiry_date = DateTime.now() + 90.days
        job.open = true
        job.job_price_id = JobPrice.find_by(internal_name: 'free').id
        job.job_type_id = JobType.find_by(internal_name: 'full_time').id
        job.level_id = Level.find_by(internal_name: 'intermediate').id
        job.category_id = Category.find_by(internal_name: 'web_development').id
        job.url = result["slug"]
        job.user_id = User.where(user_type_id: 3).first.id
      end
    end
  end
end
