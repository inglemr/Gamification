class Event < ActiveRecord::Base
	validates :day_time, presence: true
  resourcify
  belongs_to :users
end
