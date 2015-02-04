#= require jquery
#= require jquery_ujs
#= require js-routes
#= require record_collection/all
#= require_tree .
#= require_self
$ ->
  $(document).multi_select()
  $(document).optionals()
