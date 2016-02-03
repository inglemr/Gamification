class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps null: false
      t.string :event_name
      t.string :department
      t.integer :attendance
      t.timestamp  :day_time
      t.string :location
      t.integer :point_val
      t.integer :user_id
      t.text :description
      t.string :image
    end
  end
end
