source 'https://rubygems.org'

ruby '3.2.2'

gem 'a9n', '~> 1.5'
gem 'bootsnap', require: false
gem 'faraday', '~> 2.7'
gem 'puma', '>= 5.0'
gem 'rack-attack', '~> 6.7'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

group :development do
  gem 'web-console', '>= 4.2.1'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'irb'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '6.0.3'
  gem 'rubocop', require: false
  gem 'rubocop-gitlab-security'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.1'
end
