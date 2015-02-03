class MultiSelect
  setup: (table) ->
    return unless table and table.length
    table.data 'multi_select', @
    @set 'table', table

    @set 'resource', table.data('resource')
    # Add an extra th to all header rows
    table.find('thead tr').each -> $(this).prepend("<th></th>")

    # Create a toggle for selecting an deselecting all records
    # and add it to the last header row
    #toggle_all = $("<input type='checkbox'></input>").addClass('selection-toggle-all').click ->
      #checked = $(this).is(':checked')
      #table.find('td.selection input').prop 'checked', checked
    toggle_all = $("<span></span>").addClass('selection-toggle-all unchecked').click ->
      if $(this).hasClass('checked')
        table.find('td.selection .checker').removeClass('checked').addClass('unchecked')
        $(this).removeClass('checked').addClass('unchecked')
      else
        table.find('td.selection .checker').removeClass('unchecked').addClass('checked')
        $(this).removeClass('unchecked').addClass('checked')
    table.find('thead tr:last th:first').append toggle_all

    # Create a toggle/checkbox for all records and add it to the row
    #record_toggle = $("<input type='checkbox'></input>")
    record_toggle = $("<span></span>").addClass('checker unchecked').click ->
      if $(this).hasClass('checked')
        $(this).removeClass('checked').addClass('unchecked')
      else
        $(this).removeClass('unchecked').addClass('checked')
    record_td = $('<td></td>').addClass('selection').append(record_toggle)
    table.find('tbody tr').prepend record_td

    @setup_selection_actions()

    toggle_all.click() if table.data('preselected')

  # Find all buttons in the table footer and attach the action given their action data attribute
  setup_selection_actions: ->
    selector = this
    @table.find('tfoot button').click ->
      $.post Routes["actions_#{selector.get('resource')}_path"](),
        ids: selector.selected_ids().toArray()
        selection_action: $(this).data('action')

  # use set and get as a good reactive pattern
  # implement the raw version, can become more complex int the future
  set: (path, value) -> @[path] = value
  get: (path) -> @[path]

  #selected_records: -> @table.find("td.selection input:checked").map( -> $(this).parents('tr').data('record') )
  selected_records: -> @table.find("td.selection .checked").map( -> $(this).parents('tr').data('record') )
  selected_ids: -> @selected_records().map( -> this.id ).toArray()
root = @
root.multi_select = new MultiSelect()
$.fn.multi_select = ->
  if @.hasClass('with-selection') or @.prop('tagName') is 'TABLE'
    select = new MultiSelect()
    root.multi_select = select
    select.setup @
  else
    @.find('table.with-selection').each (i, el)->
      select = new MultiSelect()
      root.multi_select = select
      select.setup $(el)
