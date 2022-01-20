# frozen_string_literal: true

require 'discordrb/webhooks'

class DiscordService
  attr_reader :webwook_url
  DISCORD_WEBHOOK_URL = ENV['DISCORD_WEBHOOK_URL']

  def initialize
    @webwook_url = DISCORD_WEBHOOK_URL
  end

  def send_webhook(job)
    return unless Rails.env.production?
    client = Discordrb::Webhooks::Client.new(url: @webwook_url)
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
end
