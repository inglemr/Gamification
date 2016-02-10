class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.string :building_name
    	t.string :room_number
      t.timestamps null: false
    end
  end
end
