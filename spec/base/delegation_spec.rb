require 'spec_helper'

RSpec.describe Employee::Collection do
  subject { described_class.new }

  describe '#one?' do
    it 'is false without a collection' do
      expect( subject.one? ).to be false
    end

    it 'is true with exactly one record' do
      expect( described_class.new([Object.new]).one? ).to be true
    end

    it 'is false with more than one records' do
      expect( described_class.new([Object.new, Object.new]).one? ).to be false
    end
  end

  describe '#first and #last' do
    it 'returns the first and last object of the collection' do
      o1 = Object.new
      o2 = Object.new
      expect( described_class.new([o1, o2]).first ).to be o1
      expect( described_class.new([o1, o2]).last ).to   be o2
    end
  end

  describe 'form representation' do
    it 'has prefix collection for all types in forms' do
      expect( described_class.model_name.param_key ).to eq 'collection'
    end
  end

  describe '#uniform_collection_attribute' do
    let(:collection_class){ described_class }
    describe 'boolean attribute' do
      let(:record) { Struct.new(:admin) }

      it 'returns false for mixed falsy boolean values' do
        expect( collection_class.new([record.new, record.new(false)]).uniform_collection_attribute(:admin)).to be false
      end

      it 'returns nil for mixes boolean values' do
        expect( collection_class.new([record.new, record.new(true)]).uniform_collection_attribute(:admin)).to be nil
      end

      it 'returns true for all truthy values' do
        expect( collection_class.new([record.new(true), record.new(true)]).uniform_collection_attribute(:admin)).to be true
      end
    end

    describe 'untyped attribute' do
      let(:record) { Struct.new(:section) }
      it 'returns nil for mixed values truthy and falsy' do
        collection = collection_class.new([record.new, record.new('NT2')])
        expect( collection.uniform_collection_attribute :section ).to be nil
      end

      it 'returns nil for mixed truthy values' do
        collection = collection_class.new([record.new('NT1'), record.new('NT2')])
        expect( collection.uniform_collection_attribute :section ).to be nil
      end

      it 'returns the value for all the same values, but does not set the value' do
        collection = collection_class.new([record.new('NT2'), record.new('NT2')])
        expect( collection.uniform_collection_attribute :section ).to eq 'NT2'
        expect( collection.section ).to be nil
      end

      it 'returns the value for all the same values, and sets the value if set_if_nil is given' do
        collection = collection_class.new([record.new('NT2'), record.new('NT2')])
        expect( collection.uniform_collection_attribute :section, set_if_nil: true ).to eq 'NT2'
        expect( collection.section ).to eq 'NT2'
      end

      it 'returns the value for all the same values, and does not set the value if set_if_nil is given, but already set (eg: by invalid form)' do
        collection = collection_class.new([record.new('NT2'), record.new('NT2')], section: 'Invalid set form value')
        expect( collection.uniform_collection_attribute :section, set_if_nil: true ).to eq 'NT2'
        expect( collection.section ).to eq 'Invalid set form value'
      end
    end
  end
end

