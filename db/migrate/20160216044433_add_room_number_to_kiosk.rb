class AddRoomNumberToKiosk < ActiveRecord::Migration
  def change
  	add_column(:kiosks, :room_id, :integer)
  end
end
