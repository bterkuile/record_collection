class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.boolean :finished
      t.string :state

      t.timestamps null: false
    end
  end
end
