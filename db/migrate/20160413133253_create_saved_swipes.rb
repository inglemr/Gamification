class CreateSavedSwipes < ActiveRecord::Migration
  def change
    create_table :saved_swipes do |t|
      t.string :gsw_id
      t.integer :event_id
      t.timestamps
    end
  end
end
