require 'spec_helper'

RSpec.describe 'Validations' do
  describe 'conditional validations' do
    let(:record_class){ Employee }
    let(:collection_class)  { Employee::Collection }
    it 'is valid without attribute present' do
      collection_class.new([]).should be_valid
    end

    it 'is valid with valid section attribute' do
      collection_class.new([], section: 'ABC').should be_valid
    end

    it 'is invalid with invalid section attribute' do
      collection_class.new([], section: 'SECTION3').should be_invalid
    end
  end
end
