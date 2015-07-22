require 'spec_helper'

describe ActionView::Helpers::FormBuilder do
  let(:employee){ Employee.create section: 'SE1' }
  let(:arguments){ {form_object: Employee::Collection.new([employee])} }
  subject{ described_class.new :collection, arguments[:form_object], @template, {}}
  before do
    # http://pivotallabs.com/testing-custom-form-builder/
    @template = Object.new
    @template.extend ActionView::Helpers::FormTagHelper
    @template.extend ActionView::Helpers::FormOptionsHelper
    @template.extend ActionView::Helpers::FormHelper
  end

  describe '.collection_ids' do
    it 'returns the collection ids as hidden fields' do
      subject.collection_ids.should match /^<input/
      subject.collection_ids.should match /name="ids\[\]"/
      subject.collection_ids.should match /value="#{employee.id}"/
    end

    it "does not raise when the object is not a collection object" do
      arguments[:form_object] = employee
      expect{ subject.collection_ids }.not_to raise_error
    end
  end

  describe '#get_optional_classes' do

    describe 'active/inactive' do
      it "does not include active when record has no value" do
        employee.section = nil
        subject.get_optional_classes(:section).should_not include'active'
        subject.get_optional_classes(:section).should include'inactive'
      end

      it "includes active when record has en empty value" do
        employee.section = ''
        subject.get_optional_classes(:section).should include'active'
        subject.get_optional_classes(:section).should_not include'inactive'
      end

      it 'includes active when two records have the same value' do
        employee_2 = Employee.create section: 'SE1'
        arguments[:form_object] = Employee::Collection.new([employee, employee_2])
        subject.get_optional_classes(:section).should include'active'
        subject.get_optional_classes(:section).should_not include'inactive'
      end

      it 'does not include active when two records have different values' do
        employee_2 = Employee.create section: 'SE2'
        arguments[:form_object] = Employee::Collection.new([employee, employee_2])
        subject.get_optional_classes(:section).should_not include'active'
        subject.get_optional_classes(:section).should include'inactive'
      end
    end

    describe 'one' do
      it "includes one if only one record is present" do
        subject.get_optional_classes(:section).should include'one'
      end

      it "includes one if the form record is not a collection but a normal record" do
        arguments[:form_object] = employee
        subject.get_optional_classes(:section).should include'one'
      end

      it "does not include one for a collection having more than one records" do
        employee_2 = Employee.create section: 'SE2'
        arguments[:form_object] = Employee::Collection.new([employee, employee_2])
        subject.get_optional_classes(:section).should_not include'one'
      end
    end

    describe 'error' do
      it "has no error class without any arguments set" do
        subject.get_optional_classes(:section).should_not include'error'
      end

      it "has no error class with valid argument set" do
        arguments[:form_object].update(section: 'Se9').should be_truthy
        subject.get_optional_classes(:section).should_not include'error'
      end

      it "has error class with invalid argument set" do
        arguments[:form_object].update(section: 'INVALID NAME').should be false
        subject.get_optional_classes(:section).should include'error'
      end
    end

    describe 'disabled' do
      it "adds disabled when given as option" do
        subject.get_optional_classes(:section, disabled: true).should include'disabled'
      end
    end

  end
end
