require 'action_view/helpers/form_options_helper'
class ActionView::Helpers::FormBuilder
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
    classes = get_optional_classes(attr, base_class: 'optional-boolean')
    label_tag = label(attr, options[:label])
    check_box_tag = check_box(attr, options)
    add_collection_ids @template.content_tag(:div, label_tag + check_box_tag , class: classes, data: get_data_attributes(attr))
  end

  def optional_check_box(attr, options = {})
    optional_boolean(attr, options)
  end

  def optional_input(attr, options = {})
    classes = get_optional_classes(attr, base_class: 'optional-input')
    add_collection_ids @template.content_tag(:div, input(attr, options), class: classes, data: get_data_attributes(attr))
  end

  def optional_text_field(attr, options={})
    classes = get_optional_classes(attr, base_class: 'optional-text-field')
    add_collection_ids @template.content_tag(:div, label(attr, options[:label]) + text_field(attr, options), class: classes, data: get_data_attributes(attr))
  end

  def optional_text_area(attr, options={})
    classes = get_optional_classes(attr, base_class: 'optional-text-area')
    add_collection_ids @template.content_tag(:div, label(attr, options[:label]) + text_area(attr, options), class: classes, data: get_data_attributes(attr))
  end

  def get_data_attributes(attr, options = {})
    one = true
    one = object.one? if object.is_a? RecordCollection::Base
    {attribute: attr, one: one}
  end

  def get_optional_classes(attr, options = {})
    active = false
    if object.respond_to?(:uniform_collection_attribute)
      uniform_value = object.uniform_collection_attribute(attr, set_if_nil: true)
      # The field is active when the uniform value is not nil
      active = !uniform_value.nil?
    end
    active = true unless object.public_send(attr).nil? # Activate if collection attribute is not nil
    classes = [options[:base_class] || 'optional-input', 'optional-attribute-container', attr]
    classes << (active ? 'active' : 'inactive')
    if object.is_a? RecordCollection::Base
      classes << 'one' if object.one?
    else
      # Assume normal record, this always behaves like one
      classes << 'one'
    end
    classes << 'error' if object.errors[attr].present?
    classes
  end
end

