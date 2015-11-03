require 'spec_helper'
class AfterRecordUpdateCollection < RecordCollection::Base
  attribute :section
  after_record_update{|record| record.update(admin: true) }
end
RSpec.describe AfterRecordUpdateCollection do
  subject { described_class.new }

  it "executes on the record" do
    employee = Employee.create section: 'SE1', admin: false
    described_class.new([employee]).update({})
    employee.reload
    employee.admin.should be true
  end

  it "will not be overridden by the update action itself (hence after)" do
    employee = Employee.create section: 'SE1', admin: false
    described_class.new([employee]).update(admin: false)
    employee.reload
    employee.admin.should be true
  end
end
