module RecordCollection
  class Base
    include Enumerable
    include ActiveAttr::Model

    attr_reader :collection
    protected :collection
    delegate :first, :last, :size, :length, :count, :empty?, :any?, to: :collection

    class << self
      def model_name
        RecordCollection::Name.new(self)
      end
      # Find all attributes that are specified with type boolean
      def boolean_attributes
        attributes.select{|k,v| v[:type] == ActiveAttr::Typecasting::Boolean}.keys.map(&:to_sym)
      end

      def human_attribute_name(*args)
        raise "No record_class defined and could not be inferred based on the inheritance namespace. Please define self.record_clas = ClassNameOfIndividualRecords in the collection" unless record_class.present?
        record_class.human_attribute_name(*args)
      end

      def inherited(collection_class)
        # Try to infer the baseclass from the collection inheritance and set it if possible
        collection_class.send :cattr_accessor, :record_class
        if base_class = collection_class.name.deconstantize.safe_constantize
          collection_class.record_class = base_class
        end
      end

    end

    def initialize(collection = [], params = {})
      super(params) # active attr initialize with params
      @collection = collection
    end

    # implement enumerable logic for collection
    def each(&block)
      collection.each do |record|
        if block_given?
          block.call record
        else
          yield record
        end
      end
    end

    def save
      valid? && update_collection_attributes!
    end

    def update_collection_attributes!
      each { |r| r.update changed_attributes }
    end

    def changed_attributes
      @changed_attributes ||= attributes.reject{|attr, val| val.nil? }
    end

    def persisted?
      # Behave like an update in forms
      true
    end

    def new_record?
      # Behave like an update in forms
      false
    end


    # This method returns nil when the values of `attr` in the collection
    # are mixed. Otherwise the value itself. For boolean attributes the
    # check is wether the values are truthy or falsy. If the
    #   set_if_nil: true 
    # option is given, a uniform value will be set as the collection value if
    # it is not already set. This is important since there might be a uniform
    # value in the collection, but the values of the collection are a result of
    # an invalid form submission. In this case you want to keep the values of the
    # submitted form as collection values, not the current uniform attribute.
    def uniform_collection_attribute(attr, options = {})
      attribute_spec = self.class.attributes[attr]
      raise "Attribute #{attr} not defined on collection" unless attribute_spec
      if attribute_spec[:type] == Boolean
        # For boolean attributes presence is the true or false difference
        # not the value itself
        results = map{|r| r.public_send(attr).present? }.uniq
      else
        results = map{|r| r.public_send(attr) }.uniq
      end
      return nil unless results.size == 1 # one value found
      public_send("#{attr}=", results.first) if options[:set_if_nil] and public_send(attr).nil? # set value on the object if it is uniform and not yet set
      results.first
    end

  end
end
