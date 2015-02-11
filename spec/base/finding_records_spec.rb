require 'spec_helper'

RSpec.describe Employee::Collection do
  describe '.find' do
    describe 'empty argument' do
      it 'returns an empty collection when initialized with nil' do
        described_class.find(nil).should be_a described_class
        described_class.find(nil).should be_empty
      end
      it 'returns an empty collection when initialized with empty string' do
        described_class.find('').should be_a described_class
        described_class.find('').should be_empty
      end
      it 'returns an empty collection when initialized with empty array' do
        described_class.find([]).should be_a described_class
        described_class.find([]).should be_empty
      end
    end

    describe 'existing records' do
      it "finds the records" do
        employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
        employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
        described_class.find([employee1.id, employee2.id]).collection.should match_array [employee1, employee2]
      end
    end
  end

  describe '.where' do
    it "fills the collection with records coming from the query performed on the record_class" do
      employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
      described_class.where(admin: false).ids.should eq [employee2.id]
    end
  end
end
