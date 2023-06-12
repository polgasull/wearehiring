# frozen_string_literal: true

require 'discordrb/webhooks'

class DiscordService
  attr_reader :job_alert_webhook_url, :job_upgrade_alert_webhook_url, :candidate_alert_webhook_url, :company_alert_webhook_url, :process_alert_webhook_url, :new_info_alert_webhook_url
  DISCORD_JOB_ALERT_WEBHOOK_URL = ENV['DISCORD_JOB_ALERT_WEBHOOK_URL']
  DISCORD_JOB_UPGRADE_ALERT_WEBHOOK_URL = ENV['DISCORD_JOB_UPGRADE_ALERT_WEBHOOK_URL']
  DISCORD_CANDIDATE_ALERT_WEBHOOK_URL = ENV['DISCORD_CANDIDATE_ALERT_WEBHOOK_URL']
  DISCORD_COMPANY_ALERT_WEBHOOK_URL = ENV['DISCORD_COMPANY_ALERT_WEBHOOK_URL']
  DISCORD_PROCESS_ALERT_WEBHOOK_URL = ENV['DISCORD_PROCESS_ALERT_WEBHOOK_URL']
  DISCORD_NEW_INFO_ALERT_WEBHOOK_URL = ENV['DISCORD_NEW_INFO_ALERT_WEBHOOK_URL']

  def initialize
    @job_alert_webhook_url = DISCORD_JOB_ALERT_WEBHOOK_URL
    @job_upgrade_alert_webhook_url = DISCORD_JOB_UPGRADE_ALERT_WEBHOOK_URL
    @candidate_alert_webhook_url = DISCORD_CANDIDATE_ALERT_WEBHOOK_URL
    @company_alert_webhook_url = DISCORD_COMPANY_ALERT_WEBHOOK_URL
    @process_alert_webhook_url = DISCORD_PROCESS_ALERT_WEBHOOK_URL
    @new_info_alert_webhook_url = DISCORD_NEW_INFO_ALERT_WEBHOOK_URL
  end

  def job_alert_webhook(job)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @job_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = "#{job.titl} e#{job.job_author} - #{job.location}"
        embed.description = "#{ (job.salary_from.nil? || job.salary_from == 0) ? '' : job.salary_from } € - #{ (job.salary_to.nil? || job.salary_to == 0) ? '' : job.salary_to  } €"
        embed.add_field(name: 'Category', value: job.category.name, inline: true)
        embed.url = "https://www.wearehiring.io/digital-jobs/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def job_upgrade_alert_webhook(job)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @job_upgrade_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.title
        embed.description = 
        <<~END
          #{ job.job_author } upgraded job to #{ job.job_price.name }
        END

        embed.url = "https://www.wearehiring.io/digital-jobs/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def candidate_signup_alert_webhook(candidate)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @candidate_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.title = candidate.name
        embed.description = 
        <<~END
          #{ candidate.email }
          #{ candidate.phone }
        END

        embed.url = candidate.profile_url 
        embed.timestamp = Time.now
      end
    end
  end

  def company_signup_alert_webhook(company)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @company_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.title = company.name
        embed.description = 
        <<~END
          #{ company.last_name }
          #{ company.email }
        END
        embed.timestamp = Time.now
      end
    end
  end

  def inscription_status_alert_webhook(inscription, job)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @process_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.job_author
        embed.description = 
        <<~END
          Process #{ job.title } - #{ job.reference }
          Status of  #{ inscription.user.name } has changed to #{ inscription.status }
        END

        embed.url = "https://www.wearehiring.io/digital-jobs/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def inscription_alert_webhook(candidate, job, is_we_match)
    return unless Rails.env.production?
    we_match_sentence = "has been added by we match to"
    inscribed_sentence = "has inscribed to"
    client = Discordrb::Webhooks::Client.new(url: @process_alert_webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.job_author
        embed.description = 
        <<~END
          #{ candidate.name } #{ is_we_match ? we_match_sentence : inscribed_sentence } #{ job.title }
        END

        embed.url = "https://www.wearehiring.io/digital-jobs/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def last_jobs_alert_webhook(jobs)
    return unless Rails.env.production?

    client = Discordrb::Webhooks::Client.new(url: @new_info_alert_webhook_url)
    client.execute do |builder|
      builder.content = 'Take a look at the latest 10 published jobs'
      jobs.each do |job|
        builder.add_embed do |embed|
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
          embed.title = "#{job.titl} e#{job.job_author} - #{job.location}"
          embed.description = "Salary: #{job.salary_from} € - #{job.salary_to} €"
          embed.add_field(name: 'Category', value: job.category.name, inline: true)
          embed.url = "https://www.wearehiring.io/digital-jobs/#{job.slug}"
        end
      end
    end
  end
end
