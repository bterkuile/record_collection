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

  describe "array like behaviour" do
    collection = described_class.new([1])
    Array.wrap( collection ).should == collection
  end
end
