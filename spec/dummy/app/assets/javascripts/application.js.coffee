#= require jquery
#= require jquery_ujs
#= require js-routes
#= require record_collection/multi_select
#= require record_collection/optionals
#= require_tree .
#= require_self
$ ->
  $(document).multi_select()
  $(document).optionals()
