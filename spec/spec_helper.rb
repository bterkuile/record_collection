ENV["RAILS_ENV"] = "test"

require 'pry'

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'rspec/rails'
require 'record_collection'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
DatabaseCleaner.clean_with :truncation
RSpec.configure do |config|
  config.mock_with :rspec
  config.include Dummy::Application.routes.url_helpers, type: :feature

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
