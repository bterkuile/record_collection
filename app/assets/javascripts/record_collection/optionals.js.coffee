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
  # managed by the javascript
  optionalBoolean: (container)->
    check_box = container.find('input')
    initially_checked = check_box.is(':checked')
    field_name = check_box.attr('name')

    label_text = container.find('label').text()

    value_field = $('<input>').attr('type', 'hidden').val(0)
    # Set name based on activated state
    if container.hasClass('active')
      value_field.attr 'name', field_name
    else
      value_field.attr 'name', "disabled_#{field_name}"

    # Clear the container and initialize to inactive
    container.html('')

    label = $('<span></span>').addClass('optional-boolean-label').text label_text

    activator_toggle = $('<span></span>').addClass('optional-boolean-activator-toggle').click ->
      container.toggleClass('active').toggleClass('inactive')
      if container.hasClass('active')
        value_field.attr 'name', value_field.attr('name').replace(/^disabled_/, '')
      else
        value_field.attr 'name', "disabled_#{value_field.attr('name')}"

    value_toggle = $('<span></span>').addClass('optional-boolean-toggle').click ->
      return if container.hasClass('inactive')
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

  prependActivator: (container)->
      value_field = container.find('select,input')
      # INITIAL STATE IS DISABLED, Activation by triggering click if needed
      value_field.attr 'name', "disabled_#{value_field.attr('name')}"

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
          container.removeClass('inactive')
        else
          value_field.attr 'name', "disabled_#{value_field.attr('name')}"
          #value_toggle.hide()
          container.addClass('inactive')
      activator_label = $('<span></span>').addClass('optional-input-activator-label').text label_text
      activator_container.append activator_toggle
      activator_container.append activator_label

      container.before(activator_container)

      container.find('label').remove()

      activator_toggle.click() if container.hasClass('active')

root = @
root.Optionals = new Optionals()
$.fn.optionals = ->
  optionals = new Optionals()
  optionals.setup(@)
  root.Optionals = optionals
