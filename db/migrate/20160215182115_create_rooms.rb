class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
    	t.integer :location_id
    	t.string :room_number
      t.timestamps null: false
    end
    remove_column(:locations, :room_number, :string)
  end
end
