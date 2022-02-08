# frozen_string_literal: true

require 'discordrb/webhooks'

class DiscordService
  attr_reader :job_alert_webwook_url, :candidate_alert_webwook_url, :company_alert_webwook_url, :process_alert_webwook_url
  DISCORD_JOB_ALERT_WEBHOOK_URL = ENV['DISCORD_JOB_ALERT_WEBHOOK_URL']
  DISCORD_CANDIDATE_ALERT_WEBHOOK_URL = ENV['DISCORD_CANDIDATE_ALERT_WEBHOOK_URL']
  DISCORD_COMPANY_ALERT_WEBHOOK_URL = ENV['DISCORD_COMPANY_ALERT_WEBHOOK_URL']
  DISCORD_PROCESS_ALERT_WEBHOOK_URL = ENV['DISCORD_PROCESS_ALERT_WEBHOOK_URL']

  def initialize
    @job_alert_webwook_url = DISCORD_JOB_ALERT_WEBHOOK_URL
    @candidate_alert_webwook_url = DISCORD_CANDIDATE_ALERT_WEBHOOK_URL
    @company_alert_webwook_url = DISCORD_COMPANY_ALERT_WEBHOOK_URL
    @process_alert_webwook_url = DISCORD_PROCESS_ALERT_WEBHOOK_URL
  end

  def job_alert_webhook(job)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @job_alert_webwook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.title
        embed.description = 
        <<~END
          #{ job.job_author } - #{job.remote_ok? ? "Remote" : job.location }
          #{ (job.salary_from.nil? || job.salary_from == 0) ? 'A consultar' : job.salary_from } € - #{ (job.salary_to.nil? || job.salary_to == 0) ? 'A consultar' : job.salary_to  } €
          ##{ job.category.name }
        END

        embed.url = "https://www.wearehiring.io/ofertas-empleo-digital/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def candidate_signup_alert_webhook(candidate)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @candidate_alert_webwook_url)
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
    client = Discordrb::Webhooks::Client.new(url: @company_alert_webwook_url)
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
    client = Discordrb::Webhooks::Client.new(url: @process_alert_webwook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.job_author
        embed.description = 
        <<~END
          Proceso #{ job.title } - #{ job.reference }
          El estado de #{ inscription.user.name } ha cambiado a #{ inscription.status }
        END

        embed.url = "https://www.wearehiring.io/ofertas-empleo-digital/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end

  def inscription_alert_webhook(candidate, job, is_we_match)
    return unless Rails.env.production?
    we_match_sentence = "ha sido añadido a través de We Match para la posición de"
    inscribed_sentence = "se ha inscrito para la posición de"
    client = Discordrb::Webhooks::Client.new(url: @process_alert_webwook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: job.avatar_url(:thumb))
        embed.title = job.job_author
        embed.description = 
        <<~END
          #{ candidate.name } #{ is_we_match ? we_match_sentence : inscribed_sentence } #{ job.title }
        END

        embed.url = "https://www.wearehiring.io/ofertas-empleo-digital/#{job.slug}"
        embed.timestamp = Time.now
      end
    end
  end
end
