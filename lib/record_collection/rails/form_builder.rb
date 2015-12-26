ActionView::Helpers::FormBuilder.class_eval do
  # This method adds the collection ids to the form if not already
  # added. For the lazy peaple that forget to add them manually and
  # use an optional tag
  def add_collection_ids(content)
    return content if @collection_ids_already_added
    collection_ids + content
  end

  # Return inputs for the collection ids
  def collection_ids
    @collection_ids_already_added = true
    return "".html_safe unless object.respond_to?(:map)
    @template.hidden_field_tag('ids', object.map(&:id).join(RecordCollection.ids_separator), id: nil).html_safe
  end

  def optional_boolean(attr, options = {})
    #classes = get_optional_classes(attr, options.merge(base_class: 'optional-boolean'))
    #label_tag = label(attr, options[:label])
    #check_box_tag = check_box(attr, options)
    #add_collection_ids @template.content_tag(:div, label_tag + check_box_tag , class: classes, data: get_data_attributes(attr, options))
    optional_form_element(:check_box, attr, options.reverse_merge(base_class: 'optional-boolean'))
  end
  alias_method :optional_check_box, :optional_boolean

  def optional_input(attr, options = {})
    classes = get_optional_classes(attr, options.reverse_merge(base_class: 'optional-input'))
    add_collection_ids @template.content_tag(:div, input(attr, options), class: classes, data: get_data_attributes(attr))
  end

  def optional_text_field(attr, options={})
    optional_form_element(:text_area, attr, options.reverse_merge(base_class: 'optional-text-field'))
  end

  def optional_text_area(attr, options={})
    optional_form_element(:text_area, attr, options.reverse_merge(base_class: 'optional-text-area'))
  end

  def get_optional_classes(attr, options = {})
    classes = [options[:base_class] || 'optional-input', 'optional-attribute-container', attr, active_class(attr)]
    classes << 'disabled' if options[:disabled]
    classes << 'one' if !object.is_a?(RecordCollection::Base) or object.one?
    classes << 'error' if object.errors[attr].present?
    classes
  end

  def optional_form_element(element, attr, options = {})
    classes = get_optional_classes(attr, options.reverse_merge(base_class: 'optional-text-area'))
    label_tag = label(attr, options[:label])
    element_tag = send(element, attr, options)
    content = label_tag + element_tag
    # Hint tag is empty to make it easy to implement using js. Adding it as text is a better option than hiding the text.
    # Graceful Degradation is not an option anyway
    content += @template.content_tag(:span, nil, class: 'optional-attribute-hint', data: {hint: options[:hint]}) if options[:hint].present?
    add_collection_ids @template.content_tag(:div, content, class: classes, data: get_data_attributes(attr, options))
  end

  private

  def get_data_attributes(attr, options = {})
    one = object.is_a?(RecordCollection::Base) ? object.one? : true
    attrs = {attribute: attr, one: one}
    attrs[:disabled] = true if options[:disabled]
    attrs
  end

  # The attribute is active if it is defined on the collection
  # (this can be the case when setting it nil and a validation of another attribute failed)
  # or the collection has no mixed values of that attribute
  def active_class(attr)
    active = false # default
    if object.respond_to?(:mixed_values_for_attribute?)
      active = !object.mixed_values_for_attribute?(attr, set_if_nil: true)
    end
    active = true unless object[attr].nil? # Activate if collection or record attribute is not nil
    active ? 'active' : 'inactive'
  end
end
