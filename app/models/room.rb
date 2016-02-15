class Room < ActiveRecord::Base
	validates :room_number, :presence => true, :uniqueness => {:scope => :location_id}
	belongs_to :locations
end
