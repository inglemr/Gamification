class Event < ActiveRecord::Base
	validates :day_time, presence: true
  belongs_to :users
  has_many :user_events, foreign_key: :attended_event_id
  has_many :attendees, through: :user_events, dependent: :destroy
  mount_uploader :image, ImageUploader

  def add_attendee(user)
  	if !user.attended_events.all.include?(self)
  		self.attendees << user
  		self.attendance = self.attendance + 1
  		self.save
  		true
  	else
  		false
  	end
  end
end
