require 'spec_helper'

describe 'Routing', type: :helper do

  context 'record' do
    context 'persisted' do
      subject { Employee.create section: "SE1" }
      it 'generates a proper route for a normal record' do
        helper.form_for(subject){|f| f.text_field :section}.should eq <<-FORM.split(/\n/).map(&:strip).join
          <form class="edit_employee" id="edit_employee_#{subject.id}" action="/employees/#{subject.id}" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input type="hidden" name="_method" value="patch" />
            <input type="text" value="SE1" name="employee[section]" id="employee_section" />
          </form>
        FORM
      end
    end

    context 'new record' do
      subject { Employee.new section: "SE1" }
      it 'generates a proper route for a normal record' do
        helper.form_for(subject){|f| f.text_field :section}.should eq <<-FORM.split(/\n/).map(&:strip).join
          <form class="new_employee" id="new_employee" action="/employees" accept-charset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input type="text" value="SE1" name="employee[section]" id="employee_section" />
          </form>
        FORM
      end
    end
  end

  context 'collection' do
    subject{ Employee::Collection.new([], section: 'SE9') }
    it 'generates a proper form for a collection record' do
      helper.form_for(subject){}.should eq <<-FORM.split(/\n/).map(&:strip).join
        <form class="collection_update_collection" id="collection_update_collection" action="/employees/collection_update" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" />
        </form>
      FORM
    end

    it 'generates a proper form for a collection record with as param set' do
      helper.form_for(subject, as: 'my_collection'){|f| f.text_field :section }.should eq <<-FORM.split(/\n/).map(&:strip).join
        <form class="collection_update_my_collection" id="collection_update_my_collection" action="/employees/collection_update" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <input type="text" value="SE9" name="my_collection[section]" id="my_collection_section" />
        </form>
      FORM
    end
  end
end
