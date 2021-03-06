require 'active_attr'
require 'active_model'
require "record_collection/version"
require "record_collection/name"
require "record_collection/base"
require 'record_collection/rails/routes'
require 'record_collection/rails/form_builder'
require 'record_collection/rails/form_helper'
require 'record_collection/engine'

module RecordCollection
  mattr_accessor(:ids_separator){ '~' }
end
