module JobsHelper

  def job_author(job)
    user_signed_in? && current_user.id == job.user_id
  end

  def job_expired(job)
    if (job.is_active?) 
      (job.expiry_date.to_date - Date.today).to_i
    else 
      "<span class='tag is-danger'> #{t('jobs.expired')} </span>".html_safe
    end
  end
end
