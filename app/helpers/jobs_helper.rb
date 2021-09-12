# frozen_string_literal: true

module JobsHelper

  def job_author(job)
    user_signed_in? && current_user.id == job.user_id
  end

  def job_expired(job)
    if (!job.open?) 
      "<span class='tag is-danger'> #{t('jobs.expired')} </span>".html_safe
    else 
      (job.expiry_date.to_date - Date.today).to_i
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

def job_inscriptions_counter(job)
  count = job.inscriptions.count
  (count > 1) ? "#{count} Inscritos" : "#{count} Inscrito"
end

def first_job_publication(user)
  user && (user.jobs.first(3).count < 3)
end

def post_job_toggle_title
  current_user&.jobs&.any? ? 'jobs.post_job' : 'jobs.post_job_free'
end