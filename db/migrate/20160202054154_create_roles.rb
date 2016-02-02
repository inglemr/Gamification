class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :name
      t.timestamps null: false
      t.text :description
    end
  end
end
