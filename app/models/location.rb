class Location < ActiveRecord::Base
  extend FriendlyId
  friendly_id :building_name, use: [:slugged, :history,:finders]

  validates :building_name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }
	has_many :kiosks
	has_many :events
	has_many :rooms
end
