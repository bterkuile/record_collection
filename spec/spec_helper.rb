ENV["RAILS_ENV"] = "test"

require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]
require "rails/test_help"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)

require 'pry'
require 'record_collection'
require 'fixtures/collections'

RSpec.configure do |c|
  #c.syntax = [:should]
end
