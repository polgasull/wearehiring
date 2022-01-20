source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'activerecord-session_store'
gem 'aws-sdk-rails'
gem 'axlsx', '= 2.0.1'
gem 'axlsx_rails'
gem 'best_in_place', '~> 3.0.1'
gem 'binding_of_caller'
gem 'browser', '~> 4.0'
gem 'bulma-rails'
gem 'bulma-extensions-rails'
gem 'carrierwave', '~> 1.3', '>= 1.3.1'
gem 'carrierwave-aws'
gem 'cookies_eu'
gem 'coffee-rails', '~> 4.2'
gem "devise", ">= 4.7.1"
gem 'discordrb-webhooks', '~> 3.4', '>= 3.4.2'
gem 'faraday', '~> 1.1'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'font-awesome-sass', '~> 5.8.1'
gem 'friendly_id', '~> 5.3'
gem 'geocoder'
gem 'groupdate'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'mini_magick', '~> 4.9', '>= 4.9.4'
gem 'omniauth-linkedin-oauth2', '~> 1.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'pry', '~> 0.12.2'
gem 'rails', '~> 5.1.6', '>= 5.1.6.1'
gem 'rubyzip', '= 1.0.0'
gem 'sass-rails', '~> 5.0'
gem "simple_form", ">= 5.0.0"
gem "slack-notifier"
gem 'social-share-button'
gem 'stripe', '~> 5.28'
gem 'trix', '~> 0.11.1'
gem 'twitter', '~> 7.0'
gem 'uglifier', '>= 1.3.0'
gem 'redis'
gem 'sidekiq'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'rb-readline', '~> 0.5.3'
  gem "letter_opener"
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'better_errors'
  gem 'guard'
  gem 'guard-livereload'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
