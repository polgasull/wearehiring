# frozen_string_literal: true

require 'oauth'

class TwitterService
  CONSUMER_KEY = ENV['TWITTER_CONSUMER_KEY'] 
  CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']
  ACCESS_TOKEN = ENV['TWITTER_ACCESS_TOKEN']
  ACCESS_TOKEN_SECRET = ENV['TWITTER_ACCESS_TOKEN_SECRET']

  def initialize
    @consumer = OAuth::Consumer.new(
      CONSUMER_KEY,
      CONSUMER_SECRET,
      site: 'https://api.twitter.com',
      scheme: :header,
      http_method: :post
    )
    @access_token = OAuth::AccessToken.new(@consumer, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
  end

  def tweet(text)
    tweet_body = { 'text' => text }

    response = @access_token.post('/2/tweets', tweet_body.to_json, 'Content-Type' => 'application/json')
    
    if response.code.to_i == 201
      puts "Tweet created successfully!"
    else
      puts "Error creating tweet: #{response.body}"
    end
  end

  def send_tweet(job)
    return unless Rails.env.production?

    message = 
    <<~END
    #WEAREHIRING 📢

    We are hiring #{job.title} at #{job.job_author} (#{job.remote_ok? ? 'Remote' : job.location})
    https://www.wearehiring.io/digital-jobs/#{job.slug}

    #hiring #jobAlert ##{job.category.name.parameterize(separator: '_').camelize}
    @jobquire
    END

    tweet(message)
  end

  def send_job_detail_tweet(job)
    return unless Rails.env.production?

    message = 
    <<~END
    #WEAREHIRING 📢

    #{job.job_author} is hiring 👀 a #{job.title} (#{job.remote_ok? ? 'Remote' : job.location})
    🥷 #{job.level.name} experience
    #{job.salary_to.present? && job.salary_to > 0 ? "💰 #{job.salary_from}-#{job.salary_to} €" : ''}
    https://www.wearehiring.io/digital-jobs/#{job.slug}

    ##{ job.skills.limit(3).collect(&:internal_name).join(' #').camelize }
    END

    tweet(message)
  end

  def send_last_jobs_summary
    return unless Rails.env.production?
    return unless Date.today.monday?

    message = 
    <<~END
    #WEAREHIRING 📢 🔥

    Check our last 3 Jobs 👇

    👀 #{Job.active.last(3).third.title}
    https://www.wearehiring.io/digital-jobs/#{Job.active.last(3).third.slug}

    👀 #{Job.active.last(3).second.title}
    https://www.wearehiring.io/digital-jobs/#{Job.active.last(3).second.slug}

    👀 #{Job.active.last(3).first.title}
    https://www.wearehiring.io/digital-jobs/#{Job.active.last(3).first.slug}

    #JobAlert
    END

    tweet(message)
  end

  private

  def connection
    @connection ||= Faraday.new(url: 'https://api.twitter.com/2/') do |conn|
      conn.headers['Authorization'] = "OAuth oauth_consumer_key=#{@consumer_key}, oauth_consumer_secret=#{@consumer_secret}, oauth_token=#{@access_token}, oauth_token_secret=#{@access_token_secret}"
      conn.headers['Content-Type'] = 'application/json'
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
