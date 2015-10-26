require 'spec_helper'

describe 'form_for', type: :helper do
  let(:form_html){ helper.form_for(subject){|f| f.text_field :section} }
  let(:doc){ Nokogiri::HTML form_html }
  let(:form){ doc.css('form').first }
  let(:rails_form_method){ doc.css('[name="_method"]').first.try(:[], 'value') }
  context 'record' do
    context 'persisted' do
      subject { Employee.create section: "SE1" }
      it 'generates a proper route for a normal record' do
        form['method'].should eq 'post'
        form['action'].should eq "/employees/#{subject.id}"
        rails_form_method.should eq 'patch'
      end
    end

    context 'new record' do
      subject { Employee.new section: "SE1" }
      it 'generates a proper route for a normal record' do
        form['method'].should eq 'post'
        form['action'].should eq "/employees"
        rails_form_method.should_not be_present
      end
    end
  end

  context 'collection' do
    subject{ Employee::Collection.new([], section: 'SE9') }
    it 'generates a proper form for a collection record' do
      form['method'].should eq 'post'
      form['action'].should eq "/employees/collection_update"
      rails_form_method.should_not be_present
    end

    context "with format option" do
      let(:form_html){ helper.form_for(subject, format: :json){|f| f.text_field :section } }
      it "generates an action including format" do
        form['method'].should eq 'post'
        form['action'].should eq "/employees/collection_update.json"
      end
    end

    context "with custom as: my_collection option" do
      let(:form_html){ helper.form_for(subject, as: 'my_collection'){|f| f.text_field :section } }
      it 'generates a proper form for a collection record with as param set' do
        form['method'].should eq 'post'
        form['action'].should eq "/employees/collection_update"
        rails_form_method.should_not be_present
        form['id'].should eq "collection_update_my_collection"
        form['class'].should eq "collection_update_my_collection"

        # Check field naming
        doc.css('[name="my_collection[section]"]').first['value'].should eq 'SE9'
      end
    end
  end
end
