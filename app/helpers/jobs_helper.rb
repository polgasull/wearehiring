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

def job_salary(from, to)
  if (from && to) == 0 || (from && to) == nil
    'A consultar'
  else
    "#{number_to_currency(from, precision: 0)} - #{number_to_currency(to, precision: 0)}"               
  end
end