# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'record_collection/version'

Gem::Specification.new do |spec|
  spec.name          = "record_collection"
  spec.version       = RecordCollection::VERSION
  spec.authors       = ["Benjamin ter Kuile"]
  spec.email         = ["bterkuile@gmail.com"]
  spec.summary       = %q{Manage collections of records in Ruby on Rails}
  spec.description   = %q{This gem helps you to work on subsets or rails models}
  spec.homepage      = "https://github.com/bterkuile/record_collection"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject{ |f| f =~ %r{^(docs)} }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  #spec.add_development_dependency "rspec", ">= 3.1.0"
  spec.add_development_dependency "rspec-rails", "~> 3.1"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry", ">= 0.1"
  spec.add_development_dependency "rails", "~> 4.1"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "slim-rails"
  spec.add_development_dependency "coffee-rails"
  spec.add_development_dependency "sass-rails"
  spec.add_development_dependency "font-awesome-rails"
  spec.add_development_dependency "jquery-rails"
  spec.add_development_dependency "js-routes"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "capybara-screenshot"
  spec.add_development_dependency "poltergeist"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "spring"
  spec.add_development_dependency "spring-commands-rspec"
  spec.add_development_dependency "quiet_assets"


  spec.add_runtime_dependency 'active_attr', '>= 0.8'
  spec.add_runtime_dependency 'activemodel', '>= 4.1'
  spec.add_runtime_dependency "railties", ">= 3.1"
end
