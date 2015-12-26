require 'spec_helper'

RSpec.describe RecordCollection::Base do
  describe '#refine_relation' do
    it "does not blow up when array and not ActiveRecord::Relation is given" do
      expect{ described_class.new([]).refine_relation }.not_to raise_error
      described_class.new([]).refine_relation{ }.should be_a described_class
    end
  end
end
