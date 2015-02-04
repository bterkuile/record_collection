require 'spec_helper'

class ActiveCollectionTest < RecordCollection::Base
  attribute :check1, type: Boolean
  attribute :check2, type: Boolean
  attribute :notes
  self.record_class = Project
end

RSpec.describe RecordCollection::Base do
  subject { described_class.new }

  describe '#one?' do
    it 'is false without a collection' do
      subject.one?.should be false
    end

    it 'is true with exactly one record' do
      described_class.new([Object.new]).should be_one
    end

    it 'is false with more than one records' do
      described_class.new([Object.new, Object.new]).should_not be_one
    end
  end

  describe '#first and #last' do
    it 'returns the first and last object of the collection' do
      o1 = Object.new
      o2 = Object.new
      described_class.new([o1, o2]).first.should be o1
      described_class.new([o1, o2]).last.should be o2
    end
  end

  describe 'form representation' do
    it 'has prefix collection for all types in forms' do
      ActiveCollectionTest.model_name.param_key.should eq 'collection'
    end
  end

  describe '.record_class' do
    it 'Returns the base class inferred based on namespace' do
      Employee::Collection.record_class.should eq Employee
    end

    it 'returns a specified class when explicitly set on class level' do
      ActiveCollectionTest.record_class.should eq Project
    end
  end

  describe '#update_collection_attributes!' do
    it 'Changes only attributes given by params of the collection and defined in the collection' do
      record = Employee.new(name: 'Ben', section: 'ABC', admin: true, vegan: false)
      collection = Employee::Collection.new([record], name: 'Harry', section: '', vegan: true)
      collection.update_collection_attributes!
      record.name.should eq "Ben" # not a collection attribute
      record.section.should eq "" # Blank strings are set, only nil values not
      record.admin.should be true # not given as argument to collection
      record.vegan.should be true # this one should be changed
    end
  end

  describe '#uniform_collection_attribute' do
    let(:collection_class){ ActiveCollectionTest }
    describe 'boolean attribute' do
      let(:record) { Struct.new(:check1) }

      it 'returns false for mixed falsy boolean values' do
        expect( collection_class.new([record.new, record.new(false)]).uniform_collection_attribute(:check1)).to be false
      end

      it 'returns nil for mixes boolean values' do
        expect( collection_class.new([record.new, record.new(true)]).uniform_collection_attribute(:check1)).to be nil
      end

      it 'returns true for all truthy values' do
        expect( collection_class.new([record.new(true), record.new(true)]).uniform_collection_attribute(:check1)).to be true
      end
    end

    describe 'untyped attribute' do
      let(:record) { Struct.new(:notes) }
      it 'returns nil for mixed values truthy and falsy' do
        collection = collection_class.new([record.new, record.new('NOTE2')])
        expect( collection.uniform_collection_attribute :notes ).to be nil
      end

      it 'returns nil for mixed truthy values' do
        collection = collection_class.new([record.new('NOTE1'), record.new('NOTE2')])
        expect( collection.uniform_collection_attribute :notes ).to be nil
      end

      it 'returns the value for all the same values, but does not set the value' do
        collection = collection_class.new([record.new('NOTE2'), record.new('NOTE2')])
        expect( collection.uniform_collection_attribute :notes ).to eq 'NOTE2'
        expect( collection.notes ).to be nil
      end

      it 'returns the value for all the same values, and sets the value if set_if_nil is given' do
        collection = collection_class.new([record.new('NOTE2'), record.new('NOTE2')])
        expect( collection.uniform_collection_attribute :notes, set_if_nil: true ).to eq 'NOTE2'
        expect( collection.notes ).to eq 'NOTE2'
      end

      it 'returns the value for all the same values, and does not set the value if set_if_nil is given, but already set (eg: by invalid form)' do
        collection = collection_class.new([record.new('NOTE2'), record.new('NOTE2')], notes: 'Invalid set form value')
        expect( collection.uniform_collection_attribute :notes, set_if_nil: true ).to eq 'NOTE2'
        expect( collection.notes ).to eq 'Invalid set form value'
      end
    end
  end
end
