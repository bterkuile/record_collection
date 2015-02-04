require 'spec_helper'

RSpec.feature "Multi select", type: :feature do
  scenario "Selecting all", js: true do
    employee = Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
    visit collection_edit_employees_path(ids: [employee.id])
    find('[name="commit"]').value.should eq "Update Group"
  end
end
