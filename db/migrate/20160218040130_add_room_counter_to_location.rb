class AddRoomCounterToLocation < ActiveRecord::Migration
  def change
  	add_column(:locations, :rooms_count, :integer, :default => 0)
  	Location.reset_column_information
  	Location.all.each do |p|
  		p.update_attribute :rooms_count, p.rooms.length
  	end
  end
end

