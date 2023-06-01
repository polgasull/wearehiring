# frozen_string_literal: true

class TwitterService

  def initialize; end

  def send_tweet(job)
    return unless Rails.env.production?

    message = 
    <<~END
    #WEAREHIRING 📢

    Estamos buscando a un/a #{job.title} en #{job.remote_ok? ? '(Remoto)' : job.location}
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

  def send_job_detail_tweet(job)
    return unless Rails.env.production?

    message = 
    <<~END
    #WEAREHIRING 📢

    En #{job.job_author} están buscando 👀 a un/a #{job.title} en #{job.remote_ok? ? '(Remoto)' : job.location}
    🥷 #{job.level.name} de experiencia
    💰 #{ (job.salary_to.nil? || job.salary_to == 0) ? 'A consultar' : (job.salary_from.to_s + '-' + job.salary_to.to_s) } €
    https://www.wearehiring.io/ofertas-empleo-digital/#{job.slug}

    ##{ job.skills.collect(&:internal_name).join(' #').camelize }
    END
    client = Twitter::REST::Client.new do |config| 
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY'] 
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] 
      config.access_token = ENV['TWITTER_ACCESS_TOKEN'] 
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET'] 
    end
    client.update(message)
  end

  def send_last_jobs_summary
    return unless Rails.env.production?
    return unless Date.today.monday?

    message = 
    <<~END
    #WEAREHIRING 📢 🔥

    Consulta nuestros 3 últimos jobs 👇

    👀 #{Job.active.last(3).third.title}
    https://www.wearehiring.io/ofertas-empleo-digital/#{Job.active.last(3).third.slug}

    👀 #{Job.active.last(3).second.title}
    https://www.wearehiring.io/ofertas-empleo-digital/#{Job.active.last(3).second.slug}

    👀 #{Job.active.last(3).first.title}
    https://www.wearehiring.io/ofertas-empleo-digital/#{Job.active.last(3).first.slug}

    #JobAlert
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
