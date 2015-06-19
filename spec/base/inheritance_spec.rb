require 'spec_helper'

RSpec.describe RecordCollection::Base do

  it 'Inherits attributes from parent classes' do
    class TestClass1 < RecordCollection::Base
      attribute :attr1
    end

    class TestClass2 < TestClass1
      attribute :attr2
    end
    TestClass2.attribute_names.should eq %w[attr1 attr2]
  end
end
