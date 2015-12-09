module RecordCollection
  class Base
    include Enumerable
    include ActiveAttr::Model

    attr_reader :collection
    delegate :first, :last, :size, :length, :count, :empty?, :any?, to: :collection

    class << self
      def model_name
        RecordCollection::Name.new(self)
      end

      def human_attribute_name(*args)
        raise "No record_class defined and could not be inferred based on the inheritance namespace. Please define self.record_clas = ClassNameOfIndividualRecords in the collection" unless record_class.present?
        record_class.human_attribute_name(*args)
      end

      # GETTER
      def record_class
        return @record_class if defined?(@record_class)
        @record_class = name.deconstantize.safe_constantize
      end

      # SETTER
      def record_class=(klass)
        @record_class = klass
      end

      def before_record_update(&blk)
        if blk
          @before_record_update = blk
        else
          @before_record_update
        end
      end

      def after_record_update(&blk)
        if blk
          @after_record_update = blk
        else
          @after_record_update
        end
      end

      alias_method :old_validates, :validates
      def validates(attr, options)
        # Collection nil attributes mean they do not play a role for the collection.
        # So validating when the value is nil is not the default behaviour. I to be turned on explicitly
        # by specifying allow_nil: false
        options[:allow_nil] = true unless options.has_key?(:allow_nil)
        old_validates attr, options
      end

      #FINDERS
      def find(ids)
        raise "Cannot call find on a collection object if there is no record_class defined" unless respond_to?(:record_class) && record_class
        collection = case ids.presence
          when String then record_class.find(ids.split(RecordCollection.ids_separator))
          when nil then []
          else record_class.find(Array.wrap(ids))
        end
        self.new(collection)
      end

      # Create a new collection with the scope set to the result of the query on the record_class
      def where(*args)
        new record_class.where(*args)
      end

      def all
        new record_class.all
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

    def update(attributes)
      self.attributes = attributes
      save
    end

    def update_collection_attributes!
      after_blk = self.class.after_record_update
      before_blk = self.class.before_record_update
      each do |record|
        if before_blk
          #before_blk = before_blk.to_proc unless before_blk.is_a?(Proc) # Allow symbol to proc without cumbersome notation
          if before_blk.arity.zero?
            record.instance_eval(&before_blk)
          else
            before_blk.call(record)
          end
        end
        record.update changed_attributes
        if after_blk
          #after_blk = after_blk.to_proc unless after_blk.is_a?(Proc) # Allow symbol to proc without cumbersome notation
          if after_blk.arity.zero?
            record.instance_eval(&after_blk)
          else
            after_blk.call(record)
          end
        end
      end
      self
    end

    # Return a hash of the changed attributes of the collection:
    #   {
    #     name: 'Ben',
    #     ....etc...
    #   }
    def changed_attributes
      @changed_attributes ||= attributes.reject{|attr, val| val.nil? }
    end

    def persisted?
      # Behave like an update in forms, this triggers plural routes
      false
    end

    def to_ary(*)
      self
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

    def ids
      @ids ||= map{|record| record.try(:id) }.compact
    end

    # delegate model name to class
    def model_name
      self.class.model_name
    end
  end
end
