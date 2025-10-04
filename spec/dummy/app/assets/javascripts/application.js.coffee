#= require jquery
#= require jquery_ujs
# require js-routes
#= require record_collection/all
#= require foundation.min
#= require_tree .
#= require_self
$ ->
  $(document).optionals()
  $(document).foundation()
  if selector = $(document).multi_select()
    $('#selected-records-action').click ->
      ids = selector.selected_ids()
      return alert "No records selected" unless ids.length
      window.location.href = "/employees/collection_edit?#{$.param(ids: ids)}"

window.Routes =
  collection_edit_projects_path: ({ids}) ->
    param = ids.map((id) -> encodeURI("ids[]=#{id}")).join('&')
    "/projects/collection_edit?#{param}"
  collection_edit_employees_path: ({ids}) ->
    param = ids.map((id) -> encodeURI("ids[]=#{id}")).join('&')
    "/employees/collection_edit?#{param}"
