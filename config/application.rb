require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Users
  class Application < Rails::Application
    config.load_defaults 6.1

    config.time_zone = 'America/Sao_Paulo'
    config.active_record.default_timezone = :local

    config.log_level = ENV['LOG_LEVEL']
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags = %i[subdomain uuid]
    config.logger = ActiveSupport::TaggedLogging.new(logger)

    config.cache_store = :redis_cache_store, { url: "#{ENV['REDIS_URL']}/#{ENV['REDIS_CACHE_PATH']}" }

    # config.active_job.queue_adapter = :sidekiq
    # config.active_job.queue_name_prefix = "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"

    config.api_only = true
  end
end
