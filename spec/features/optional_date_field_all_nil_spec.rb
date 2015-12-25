require 'spec_helper'

RSpec.feature "Optional  date field with multiple default nil values", type: :feature do
  scenario "Immediately setting the date when none of the collection is set", js: true do
    project_1 = Project.create name: "P1", start_date: nil
    project_2 = Project.create name: "P2", start_date: nil
    visit collection_edit_projects_path(ids: "#{project_1.id}~#{project_2.id}")
    page.should have_selector '.collection_start_date'
  end
end
