# frozen_string_literal: true

class TwitterService

  def initialize; end

  def send_tweet(job)
    return unless Rails.env.production?

    message = 
    <<~END
    #WEAREHIRING 📢

    Estamos buscando a un #{job.title} en #{job.remote_ok? ? '(Remoto)' : job.location}
    https://www.wearehiring.io/ofertas-empleo-digital/#{job.slug}

    #OfertaDeEmpleo #JobAlert #Empleos #Hiring
    @jobquire
    END
    client = Twitter::REST::Client.new do |config| 
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY'] 
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] 
      config.access_token = ENV['TWITTER_ACCESS_TOKEN'] 
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET'] 
    end
    client.update(message)
  end
end
