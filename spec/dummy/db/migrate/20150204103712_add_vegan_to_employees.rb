class AddVeganToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :vegan, :boolean, default: true
  end
end
