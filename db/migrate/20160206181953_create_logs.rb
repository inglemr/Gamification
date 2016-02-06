class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
    	t.integer :user_id
    	t.text :params
    	t.string :path
      t.timestamps null: false
    end
  end
end
