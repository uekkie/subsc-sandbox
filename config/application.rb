require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)


module AccountService
  class Application < Rails::Application
    config.application_name = 'MyPassport'
    config.load_defaults 5.2
    config.time_zone = 'Asia/Tokyo'
    config.i18n.default_locale = :ja

    # grape api settings
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
  end
end
