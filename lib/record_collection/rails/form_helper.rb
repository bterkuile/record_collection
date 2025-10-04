ActionView::Helpers::FormHelper.class_eval do
  private

  # This trick makes it possible to use the record_collection object
  # directly in to forms and point to the proper controller action
  # like:
  #   = form_for @collection do |f|
  #     = f.text_field :name
  alias_method :old_apply_form_for_options!, :apply_form_for_options!
  def apply_form_for_options!(object, options) #:nodoc:
    #binding.pry if object.is_a?(RecordCollection::Base)
    if object.is_a?(RecordCollection::Base)
        object = convert_to_model(object)

        as = options[:as]
        namespace = options[:namespace]
        action, method = [:collection_update, :post]
        options[:html] ||= {}
        options[:html].reverse_merge!(
          class:  as ? "#{action}_#{as}" : dom_class(object, action),
          id:     (as ? [namespace, action, as] : [namespace, dom_id(object, action)]).compact.join("_").presence,
          method: method
        )

        options[:url] ||= if options.key?(:format)
                            polymorphic_path([action, object], format: options.delete(:format))
                          else
                            polymorphic_path([action, object], {})
                          end
    else
      old_apply_form_for_options!(object, options)
    end
  end
end
