require 'spec_helper'

RSpec.describe ActionView::Helpers::FormBuilder do
  let(:employee){ Employee.create section: 'SE1' }
  subject{ described_class.new :collection, Employee::Collection.new([employee]), @template, {}}
  before do
    # http://pivotallabs.com/testing-custom-form-builder/
    @template = Object.new
    @template.extend ActionView::Helpers::FormTagHelper
    @template.extend ActionView::Helpers::FormOptionsHelper
    @template.extend ActionView::Helpers::FormHelper
  end

  describe '.collection_ids' do
    it 'returns the collection ids as hidden fields' do
      subject.collection_ids.should eq %{<input type="hidden" name="ids[]" value="#{employee.id}" />}
    end

    it "does not raise when the object is not a collection object" do
      form_builder = described_class.new :employee, employee, @template, {}
      expect{ form_builder.collection_ids }.not_to raise_error
    end
  end
end
