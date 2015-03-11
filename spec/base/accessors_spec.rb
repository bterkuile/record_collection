require 'spec_helper'

RSpec.describe RecordCollection::Base do

  describe '#ids' do
    it 'returns the ids of the collection' do
      employee = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      described_class.new([employee]).ids.should eq [employee.id]
    end

    it 'Filters out nil records' do
      employee = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      described_class.new([employee, nil]).ids.should eq [employee.id]
    end

    it 'returns an empty array for an empty collection' do
      described_class.new.ids.should be_empty
    end
  end
end
