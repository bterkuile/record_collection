require 'spec_helper'
class BeforeRecordUpdateCollection < RecordCollection::Base
  attribute :section
  before_record_update{|record| record.update(admin: true) }
end
RSpec.describe BeforeRecordUpdateCollection do
  subject { described_class.new }
  it "executes on the record" do
    employee = Employee.create section: 'SE1', admin: false
    described_class.new([employee]).update({})
    employee.reload
    employee.admin.should be true
  end
end
