require 'spec_helper'

RSpec.feature "Optional  text_field with normal record", type: :feature do
  scenario "Selecting all", js: true do
    employee = Employee.create name: 'E1', admin: true, vegan: false
    visit edit_employee_path(employee.id)

    find('#employee_section').set 'SEC' # this is an optional
    find('[name="commit"]').click

    employee.reload

    employee.section.should == 'SEC'
  end

end
