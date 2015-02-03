module RecordCollection
  class Name < ActiveModel::Name
    def param_key
      'collection'
    end
  end
end
