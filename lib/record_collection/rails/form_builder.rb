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
    object.map{|record| @template.hidden_field_tag('ids[]', record.id, id: nil) }.join.html_safe
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
    add_collection_ids @template.content_tag(:div, label(attr, options[:label]) + send(element, attr, options), class: classes, data: get_data_attributes(attr, options))
  end

  private

  def get_data_attributes(attr, options = {})
    one = object.is_a?(RecordCollection::Base) ? object.one? : true
    attrs = {attribute: attr, one: one}
    attrs[:disabled] = true if options[:disabled]
    attrs
  end

  def active_class(attr)
    active = false # default
    if object.respond_to?(:uniform_collection_attribute)
      uniform_value = object.uniform_collection_attribute(attr, set_if_nil: true)
      # The field is active when the uniform value is not nil, 
      # aka has a value
      active = !uniform_value.nil?
    end
    active = true unless object.public_send(attr).nil? # Activate if collection or record attribute is not nil
    active ? 'active' : 'inactive'
  end
end
