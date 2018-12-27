require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BookLibrary
  class Application < Rails::Application
    config.application_name = 'MyPassport'
    config.load_defaults 5.2
    config.time_zone = 'Asia/Tokyo'
    config.i18n.default_locale = :ja
  end
end
