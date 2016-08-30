source 'https://rubygems.org'

# Specify your gem's dependencies in record_collection.gemspec
gemspec path: '../'

gem "rails", "~> 4.2.7"

group :test do
  gem "codeclimate-test-reporter", require: nil
end
