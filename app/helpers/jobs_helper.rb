module JobsHelper

  def job_author(job)
    user_signed_in? && current_user.id == job.user_id
  end
end
