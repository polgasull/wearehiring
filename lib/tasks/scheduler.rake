desc "This task is called by the Heroku scheduler add-on"
task :update_expired_jobs => :environment do
  puts "Updating expired jobs..."
  Job.close_expired_jobs
  puts "done."
end

task :user_update_residence_info => :environment do
  puts "Updating user residence info..."
  User.update_residence_info
  puts "done."
end

task :send_last_jobs_tweet_notification => :environment do
  puts "Sending Tweet send_last_jobs_summary"
  TwitterService.new.send_last_jobs_summary
  puts "done."
end

task :fetch_talent_hackers_jobs => :environment do
  puts "Fetching talent hackers jobs"
  Job.create_jobs_from_talent_hackers
  puts "done."
end

task :fetch_remote_ok_jobs => :environment do
  puts "Fetching remote ok jobs"
  Job.create_jobs_from_remote_ok
  puts "done."
end

task :fetch_apijobs_jobs => :environment do
  puts "Fetching apijobs jobs"
  Job.create_jobs_from_apijobs
  puts "done."
end

task :fetch_timup_jobs => :environment do
  puts "Fetching timup jobs"
  Job.create_jobs_from_timup
  puts "done."
end

task :send_random_active_job_notification => :environment do
  puts "Sending Tweet send_random_active_job_notification"
  Job.send_random_active_job_tweet_notification
  puts "done."
end

task :send_last_jobs_alert => :environment do
  puts "Sending Alert (normally at discord) send_last_jobs_alert_with_salary"
  Job.send_last_jobs_with_salary
  puts "done."
end
