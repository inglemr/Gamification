class Event < ActiveRecord::Base
	validates :day_time, presence: true
  belongs_to :users
  mount_uploader :image, ImageUploader
end
