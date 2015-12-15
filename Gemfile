source 'https://rubygems.org'

# Specify your gem's dependencies in record_collection.gemspec
gemspec

#http://aaronmiler.com/blog/testing-your-rails-engine-with-multiple-versions-of-rails/
rails_version = ENV["RAILS_VERSION"] || "default"
rails = case rails_version
  when "master" then {github: "rails/rails"}
  when "default" then ">= 3.2.0"
  else "~> #{rails_version}"
end
gem "rails", rails
if rails_version == 'master'
  gem 'arel', github: 'rails/arel'
  gem 'rack', github: 'rack/rack'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
end
