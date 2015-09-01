require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VQEV2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # These path autoload .rb files contained in /lib and vendor, such as the spokenDataAPI
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/vendor)


    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    # Version of your assets, change this if you want to expire all your assets
    # This config loads up the enviroment varibales specified in local_env.yml, this file is in git ignore for security reasons.

    # config.active_record.observers = :video_observer


    # config.assets.precompile += %w(welcome.css)

    config.assets.version = '1.0'
    #     config.before_configuration do
    #     env_file = File.join(Rails.root, 'config', 'local_env.yml')
    #     YAML.load(File.open(env_file)).each do |key, value|
    #     ENV[key.to_s] = value
    #     end if File.exists?(env_file)
    # end
  end
end
