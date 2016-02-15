class Room < ActiveRecord::Base
	validates :room_number, :presence => true, :uniqueness => {:scope => :location_id, message: "Room number already exists for this location"}
	belongs_to :locations
end
