class Event < ActiveRecord::Base
	validates :day_time, presence: true
  belongs_to :users
  has_many :attendees, through: :user_events, source: :attendee_id, dependent: :destroy
  mount_uploader :image, ImageUploader
end
