class AddRoomToEvent < ActiveRecord::Migration
  def change
  	add_column(:events, :room_numbers, :text, array: true, default: [])
  end
end
