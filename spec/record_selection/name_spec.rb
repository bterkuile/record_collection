require 'spec_helper'

describe RecordCollection::Name do
  let(:employee){ Employee.create section: 'SE1' }
  subject{ Employee::Collection.new([employee]).model_name }

  its(:singular_route_key){ should eq 'employee' }
  its(:route_key){ should eq 'employees' }
  its(:human){ should eq 'Employees collection' }
end
