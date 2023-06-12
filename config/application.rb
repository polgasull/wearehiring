require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
impressionist_dir = Gem::Specification.find_by_name('impressionist').gem_dir
require File.join(impressionist_dir, '/app/controllers/impressionist_controller.rb')

module JobApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.ignored_paths = %W(/users /users/sign_in /users/sign_up /users/password /users/sign_out /users/confirm_password)
    config.time_zone = 'Madrid'
    config.active_record.default_timezone = :utc
    config.active_record.time_zone_aware_types = %i[datetime time]

    config.active_job.queue_adapter = :sidekiq
    config.application_name = 'Job App'

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.assets.initialize_on_precompile = false
    config.serve_static_assets = true
    config.exceptions_app = self.routes
    config.middleware.use Rack::Deflater
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
