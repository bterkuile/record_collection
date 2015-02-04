module RecordCollection
  class Name < ActiveModel::Name
    def param_key
      'collection'
    end

    def singular_route_key
      @klass.record_class.model_name.singular_route_key
    end

    def route_key
      @klass.record_class.model_name.route_key
    end

    def human
      I18n.t("#{@klass.record_class.i18n_scope}.collections.#{@klass.record_class.model_name.i18n_key}", default: 'Collection')
    end
  end
end
