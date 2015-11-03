require 'spec_helper'
class BeforeRecordUpdateCollection < RecordCollection::Base
  attribute :section
  attribute :admin
  before_record_update{|record| record.admin = true }
end
RSpec.describe BeforeRecordUpdateCollection do
  subject { described_class.new }
  it "executes on the record" do
    employee = Employee.create section: 'SE1', admin: false
    described_class.new([employee]).update({})
    employee.reload
    employee.admin.should be true
  end

  it "will be overriden by the actual update action (hence before)" do
    employee = Employee.create section: 'SE1', admin: false
    described_class.new([employee]).update(admin: false)
    employee.reload
    employee.admin.should be false
  end
end
