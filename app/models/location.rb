class Location < ActiveRecord::Base
	has_many :kiosks
	has_many :events
end
