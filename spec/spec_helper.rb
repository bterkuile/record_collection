ENV["RAILS_ENV"] = "test"

require 'pry'

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]
require "rails/test_help"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)


require 'record_collection'
#require 'fixtures/collections'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

#Capybara.app = Dummy::Application
Capybara.javascript_driver = :poltergeist
DatabaseCleaner.clean_with :truncation
RSpec.configure do |config|
  #c.syntax = [:should]
  config.mock_with :rspec
  config.include Dummy::Application.routes.url_helpers, type: :feature
  #config.before(:suite) do
    #DatabaseCleaner.clean
  #end
  #config.around(:each) do |example|
    #DatabaseCleaner.cleaning do
      #example.run
    #end
  #end
end
