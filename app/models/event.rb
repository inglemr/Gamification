class Event < ActiveRecord::Base
  after_create :set_attendance
	validates :day_time, presence: true
  validates :end_time, presence: true
  validates :room_numbers, presence: true
  validates :location_id, presence: true
  validates :point_val, presence: true
  belongs_to :users
  has_many :user_events, foreign_key: :attended_event_id
  has_many :attendees, through: :user_events, dependent: :destroy
  has_one :location, foreign_key: :location_id
  mount_uploader :image, ImageUploader

  scope :upcoming_first , lambda { order("events.day_time ASC")}
  scope :past_events, lambda {("events.day_time > #{Time.now}")}

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
