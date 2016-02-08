class Event < ActiveRecord::Base
  after_create :set_attendance
	validates :day_time, presence: true
  validates :point_val, presence: true
  belongs_to :users
  has_many :user_events, foreign_key: :attended_event_id
  has_many :attendees, through: :user_events, dependent: :destroy
  mount_uploader :image, ImageUploader

  def add_attendee(user)
  	if !user.attended_events.all.include?(self)
  		self.attendees << user
  		self.attendance = self.attendance.to_f + 1
      user.points = user.points.to_f + self.point_val.to_f
      user.events_attended = 0
      user.save
  		self.save
  		true
  	else
  		false
  	end
  end

  def set_attendance
    self.attendance = 0;
    self.save
  end
end
