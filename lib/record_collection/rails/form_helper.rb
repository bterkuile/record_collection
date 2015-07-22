ActionView::Helpers::FormHelper.class_eval do
  private

  alias_method :old_apply_form_for_options!, :apply_form_for_options!
  def apply_form_for_options!(record, object, options) #:nodoc:
    if record.is_a?(RecordCollection::Base)
        object = convert_to_model(object)

        as = options[:as]
        namespace = options[:namespace]
        action, method = [:collection_update, :post]
        options[:html].reverse_merge!(
          class:  as ? "#{action}_#{as}" : dom_class(object, action),
          id:     (as ? [namespace, action, as] : [namespace, dom_id(object, action)]).compact.join("_").presence,
          method: method
        )

        options[:url] ||= if options.key?(:format)
                            polymorphic_path([action, record], format: options.delete(:format))
                          else
                            polymorphic_path([action, record], {})
                          end
    else
      old_apply_form_for_options!(record, object, options)
    end
  end
end
