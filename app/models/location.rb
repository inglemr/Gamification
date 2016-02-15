class Location < ActiveRecord::Base
validates :building_name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }
	has_many :kiosks
	has_many :events
	has_many :rooms
end
