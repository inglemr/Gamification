class Room < ActiveRecord::Base
  has_and_belongs_to_many :events
	validates :room_number, :presence => true, :uniqueness => {:scope => :location_id, message: "Room number already exists for this location"}
	belongs_to :locations, :counter_cache => true
end
