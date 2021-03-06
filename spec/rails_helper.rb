require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
  add_filter '/spec/models'
  add_filter '/config/'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'
  add_group 'Mailers', 'app/mailers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Helpers', 'app/helpers'
end
SimpleCov.at_exit do
  SimpleCov.result.format!
end

include Rails.application.routes.url_helpers
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
