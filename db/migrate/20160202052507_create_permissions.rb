class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
    	t.string :name
    	t.string :subject_class
    	t.text :description
    	t.string :action
    	t.integer :subject_id
      t.timestamps null: false
    end
  end
end
