require 'spec_helper'

RSpec.feature "Hint with optional boolean", type: :feature do
  scenario "Seeing the hint", js: true do
    project = Project.create name: 'P1', finished: true
    visit collection_edit_projects_path(ids: [project.id])

    page.should have_selector '.optional-attribute-container.hint_visible .optional-attribute-hint'
  end

end
