require 'spec_helper'

RSpec.feature "Optional  text_field with normal record", type: :feature do
  scenario "Selecting all", js: true do
    employee = Employee.create name: 'E1', admin: true, vegan: false
    visit collection_edit_employees_path(ids: [employee.id])

    find('#collection_section').set 'SEC' # this is an optional
    toggle = find('.optional-attribute-container.vegan .optional-boolean-toggle')
    toggle.click
    find('[name="commit"]').click

    employee.reload

    employee.section.should == 'SEC'
    employee.admin.should be true
    employee.vegan.should be true
  end

end
