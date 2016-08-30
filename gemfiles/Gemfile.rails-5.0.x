source 'https://rubygems.org'

# Specify your gem's dependencies in record_collection.gemspec
gemspec path: '../'

gem "rails", "~> 5.0.0"

group :test do
  gem "codeclimate-test-reporter", require: nil
end
