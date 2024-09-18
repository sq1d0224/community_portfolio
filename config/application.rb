require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommunityPortfolio
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # タイムゾーンを日本標準時に設定
    config.time_zone = 'Asia/Tokyo'

    # Active Record のタイムゾーンを設定
    config.active_record.default_timezone = :local

    # I18nの設定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ja

    # その他のアプリケーション設定
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
