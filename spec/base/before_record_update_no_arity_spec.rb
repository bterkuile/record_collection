require 'spec_helper'
class BeforeRecordUpdateNoArityCollection < RecordCollection::Base
  attribute :section
  attribute :admin
  before_record_update{ do_a_trick }
end

RSpec.describe BeforeRecordUpdateNoArityCollection do
  subject { described_class.new }
  it "triggers the method" do
    employee = Employee.create section: 'SE1', admin: false
    expect( employee ).to receive :do_a_trick
    described_class.new([employee]).update({})
  end
end
