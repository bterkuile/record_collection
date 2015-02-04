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
  end
end
