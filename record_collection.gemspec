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
  spec.description   = %q{This gem is there to aid you to work on subsets or rails models. This gem helps you to create forms and controllers that act on collections of models}
  spec.homepage      = "http://www.companytools.nl/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails", ">= 3.1.0"
  spec.add_development_dependency "pry", ">= 0.1"
  spec.add_development_dependency "rails", ">= 4.2.0"
  spec.add_development_dependency "sqlite3"

  spec.add_runtime_dependency 'active_attr', '>= 0.8.5'
  spec.add_runtime_dependency 'activemodel', '>= 4.1'
end
