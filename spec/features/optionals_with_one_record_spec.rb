require 'spec_helper'

RSpec.feature "Optionals with one record", type: :feature do
  scenario "Selecting all", js: true do
    employee = Employee.create name: 'E1', admin: true, vegan: false
    visit collection_edit_employees_path(ids: [employee.id])

    find('#collection_section').set 'SEC'
    find('[name="commit"]').click

    employee.reload

    employee.section.should == 'SEC'
  end

end
