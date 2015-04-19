require 'spec_helper'

RSpec.feature "Disabled booleans", type: :feature do
  scenario "Selecting all", js: true do
    project = Project.create name: 'P1', finished: true
    visit collection_edit_projects_path(ids: [project.id])

    toggle = find('.optional-attribute-container.finished .optional-boolean-toggle')
    toggle['class'].should include 'active'
    toggle.click
    find('[name="commit"]').click

    project.reload

    # Should not be changed by the click
    project.finished.should be true
  end

end
