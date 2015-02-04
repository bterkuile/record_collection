class AddAdminToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :admin, :boolean, default: false
  end
end
