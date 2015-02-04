require 'spec_helper'

RSpec.feature "Multi select", type: :feature do
  scenario "Selecting all", js: true do
    Employee.create name: 'E1', section: 'ABC', admin: true, vegan: false
    Employee.create name: 'E2', section: 'QNP', admin: false, vegan: false
    visit employees_path
    find('.selection-toggle-all').click
    find('.actions-button').click

    page.should have_selector ".optional-input-activator-container.section.inactive"
    page.should_not have_selector ".optional-attribute-container.section" # hidden
    page.should have_selector ".optional-attribute-container.admin.inactive"
    page.should have_selector ".optional-attribute-container.vegan.active"

    # Activate admin, and see that they all become false
    find('.admin .optional-boolean-activator-toggle').click
    find('[name="commit"]').click

    Employee.pluck(:admin).should be_none

  end
end
