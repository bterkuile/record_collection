class AddHintVisibleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :hint_visible, :boolean, null: false, default: false
  end
end
