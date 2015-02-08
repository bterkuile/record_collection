require 'spec_helper'

RSpec.describe 'Validations' do
  let(:collection_class)  { Employee::Collection }
  describe 'conditional validations' do
    let(:record_class){ Employee }
    it 'is valid without attribute present' do
      collection_class.new([]).should be_valid
    end

    it 'is valid with valid section attribute' do
      collection_class.new([], section: 'ABC').should be_valid
    end

    it 'is invalid with invalid section attribute' do
      collection_class.new([], section: 'SECTION3').should be_invalid
    end
    describe '#save' do
      it 'does not trigger update_collection_attributes! for invalid collection' do
        collection = collection_class.new [], section: 'INVALID_SECTION_NAME'
        collection.should_not receive :update_collection_attributes!
        collection.save
      end
    end
  end
end
