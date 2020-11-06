# frozen_string_literal: true

require 'slack-notifier'

class SlackService
  attr_reader :webwook_url, :webwook_error_url

  def initialize
    @webwook_url = 'https://hooks.slack.com/services/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'
  end

  def ping_channel_message(message, channel)
    return unless Rails.env.production?

    notifier = Slack::Notifier.new @webwook_url, channel: channel
    notifier.ping message.to_s
  rescue StandardError => e
    Rails.logger.error e.message
    e.backtrace.each { |line| Rails.logger.error line }
  end
end