require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommunityPortfolio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

module CommunityPortfolio
  class Application < Rails::Application
    config.i18n.default_locale = :ja
  end
end

module CommunityPortfolio
  class Application < Rails::Application
    # タイムゾーンを日本標準時に設定
    config.time_zone = 'Asia/Tokyo'

    # Active Record のタイムゾーンを設定
    config.active_record.default_timezone = :local
  end
end
