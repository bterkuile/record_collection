require 'spec_helper'

RSpec.describe Employee::Collection do
  describe '.find' do
    describe 'empty argument' do
      it 'returns an empty collection when initialized with nil' do
        described_class.find(nil).should be_a described_class
        described_class.find(nil).should be_empty
      end
      it 'returns an empty collection when initialized with empty string' do
        described_class.find('').should be_a described_class
        described_class.find('').should be_empty
      end
      it 'returns an empty collection when initialized with empty array' do
        described_class.find([]).should be_a described_class
        described_class.find([]).should be_empty
      end
    end

    describe 'existing records' do
      it "finds the records" do
        employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
        employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
        described_class.find([employee1.id, employee2.id]).collection.should match_array [employee1, employee2]
      end

      it "works with an includes statement (find on instance)" do
        employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
        described_class.includes(:project).find([employee1.id]).should be_a RecordCollection::Base
      end

      it "works with an includes statement (find on instance) and string argument" do
        employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
        employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
        result = described_class.includes(:project).find("#{employee1.id}~#{employee2.id}")
        result.should be_a RecordCollection::Base
        result.collection.should match_array [employee1, employee2]
      end

      it "works with an includes statement (find on instance) and integer id argument" do
        employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
        result = described_class.includes(:project).find(employee1.id)
        result.should be_a RecordCollection::Base
        result.collection.should eq [employee1]
      end
    end

    it "finds single id as string as collection" do
      employee = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      described_class.find(employee.id).collection.should eq [employee]
    end

    it 'finds multiple records from a tilde separated string' do
      employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
      described_class.find("#{employee1.id}~#{employee2.id}").collection.should match_array [employee1, employee2]
    end
  end

  describe '.where' do
    it "fills the collection with records coming from the query performed on the record_class" do
      employee1 = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      employee2 = Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
      described_class.where(admin: false).ids.should eq [employee2.id]
    end
  end

  describe '.all' do
    it 'finds all record and makes it part of the collection' do
      employee = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
      described_class.all.collection.should eq [employee]
    end
  end

  describe '.joins' do
    let(:project_1){ Project.create name: 'P1', finished: true }
    let(:project_2){ Project.create name: 'P2', finished: false }
    let!(:employee_1){ Employee.create name: 'E1', section: 'ABC', project: project_1 }
    let!(:employee_2){ Employee.create name: 'E1', section: 'ABC', project: project_2 }
    it "returns a scope having a joins activated without further arguments" do
      result = described_class.joins(:project)
      result.should be_a RecordCollection::Base
      result.map(&:project).should match_array [project_1, project_2]
    end

    it "modifies the scope when a .where clause is applied on an existing relation" do
      result = described_class.joins(:project).where(projects: {finished: true})
      result.should be_a RecordCollection::Base
      result.map(&:project).should eq [project_1]
    end

    it "modifies the scope when a .where.not clause is applied on an existing relation" do
      result = described_class.joins(:project).where.not(projects: {finished: true})
      result.should be_a RecordCollection::Base
      result.map(&:project).should eq [project_2]
    end
  end
end
