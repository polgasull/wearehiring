require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JobApp
  class Application < Rails::Application

    config.ignored_paths = %W(/users /users/sign_in /users/sign_up /users/password /users/sign_out /users/confirm_password)
    config.time_zone = 'Madrid'
    config.active_record.default_timezone = :utc
    config.active_record.time_zone_aware_types = %i[datetime time]

    config.active_job.queue_adapter = :sidekiq
    config.application_name = 'Job App'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es
    config.assets.initialize_on_precompile = false
    config.serve_static_assets = true
    config.exceptions_app = self.routes
    config.middleware.use Rack::Deflater

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
