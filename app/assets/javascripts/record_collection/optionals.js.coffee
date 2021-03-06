class Optionals
  setup: (target)->
    @setup_inputs(target)

  setup_inputs: (target)->
    target.find('.optional-attribute-container').each (i, el)=>
      container = $(el)
      if container.hasClass('optional-boolean')
        @optionalBoolean container
      else
        @prependActivator(container)

  # Replace the <input type="checkbox"> for a <input type="hidden" # value="0|1"> fields
  # managed by the javascript. The strategy is to completely rebuild the html structure
  optionalBoolean: (container)->
    check_box = container.find('input')
    initially_checked = check_box.is(':checked')
    field_name = check_box.attr('name')
    one = container.data('one')
    hint_field = container.find('.optional-attribute-hint')
    append_text_field = container.find('.optional-attribute-append')

    label_text = container.find('label').text()

    value_field = $('<input>').attr('type', 'hidden').val(0)
    # Set name based on activated state
    if one or container.hasClass('active')
      value_field.attr 'name', field_name
    else
      value_field.attr 'name', "disabled_#{field_name}"

    # Clear the container and initialize to inactive
    container.html('')

    activator_toggle = $('<span></span>').addClass('optional-boolean-activator-toggle').click ->
      container.toggleClass('active').toggleClass('inactive')
      if container.hasClass('active')
        value_field.attr 'name', value_field.attr('name').replace(/^disabled_/, '')
      else
        value_field.attr 'name', "disabled_#{value_field.attr('name')}"

    label = $('<span></span>').addClass('optional-boolean-label').text label_text
    label.click ->
      if container.hasClass('inactive')
        activator_toggle.click()

    value_toggle = $('<span></span>').addClass('optional-boolean-toggle').click ->
      return if container.hasClass('inactive')
      return if container.data('disabled')
      if $(@).hasClass('active')
        value_field.val(0)
        $(@).removeClass('active').addClass('inactive')
      else
        value_field.val(1)
        $(@).addClass('active').removeClass('inactive')

    if initially_checked
      value_toggle.addClass('active')
      value_field.val(1)
    else
      value_toggle.addClass('inactive')

    container.append activator_toggle
    container.append label
    container.append value_toggle
    container.append value_field
    container.append hint_field if hint_field.length
    container.append append_text_field if append_text_field.length
    activator_toggle.hide() if one

  prependActivator: (container)->
      value_field = container.find('select,input,textarea')
      # INITIAL STATE IS DISABLED, Activation by triggering click if needed
      value_field.attr 'name', "disabled_#{value_field.attr('name')}"
      container.addClass('inactive')
      one = container.data('one')

      label_text = container.find('label').text()

      # Activator container
      activator_container = $('<div></div>').addClass('optional-input-activator-container inactive')
      activator_container.addClass container.data('attribute')
      activator_container.addClass('error') if container.hasClass('error')
      activator_toggle = $('<span></span>').addClass('optional-input-activator-toggle').click ->
        activator_container.toggleClass('active').toggleClass('inactive')
        #label.toggleClass('inactive')
        if activator_container.hasClass('active')
          value_field.attr 'name', value_field.attr('name').replace(/^disabled_/, '')
          #value_toggle.show()
          container.addClass('active').removeClass('inactive')
        else
          value_field.attr 'name', "disabled_#{value_field.attr('name')}"
          #value_toggle.hide()
          container.removeClass('active').addClass('inactive')
      activator_label = $('<span></span>').addClass('optional-input-activator-label').text label_text
      activator_label.click ->
        if activator_container.hasClass('active')
          # Focus on element
          value_field.focus()
        else
          # Activate the optional
          activator_toggle.click()
      activator_container.append activator_toggle
      activator_container.append activator_label

      container.before(activator_container)

      container.find('label').remove()

      activator_toggle.click() if container.hasClass('active') or one
      activator_toggle.hide() if one

root = @
root.Optionals = new Optionals()
$.fn.optionals = (action_or_options = {})->
  if typeof action_or_options is 'string'
    #nothing
  else
    optionals = new Optionals(action_or_options)
    optionals.setup(@)
    root.Optionals = optionals
