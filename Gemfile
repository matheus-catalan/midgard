source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.0'

gem 'jbuilder', '~> 2.7'

gem 'redis', '~> 4.0'

gem 'bcrypt'
gem 'jwt'

gem 'figaro'

gem 'factory_bot'

gem 'rack-cors'

gem 'activestorage-validator'

gem 'image_processing', '~> 1.2'
gem 'mini_magick'
gem 'oj'

gem 'searchkick', '4.4.2'
gem 'sidekiq'
gem 'sinatra', require: false

gem 'bootsnap', '>= 1.4.4', require: false

gem 'hashie'
gem 'pry-byebug'
gem 'pry-rails'
gem 'pry-stack_explorer'

gem 'lograge'
gem 'logstash-event'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rswag-specs'
end

group :development do
  gem 'listen', '~> 3.3'

  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring'

  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'mocha'
  gem 'simplecov', '~> 0.16.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
