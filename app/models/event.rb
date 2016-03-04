class Event < ActiveRecord::Base
  after_create :set_attendance
	validates :day_time, presence: true
  validates :end_time, presence: true
  validates :location_id, presence: true
  validates :point_val, presence: true
  belongs_to :users
  has_many :user_events, foreign_key: :attended_event_id
  has_many :attendees, through: :user_events, dependent: :destroy
  has_one :location, foreign_key: :location_id
  mount_uploader :image, ImageUploader

  scope :upcoming_first , lambda { order("events.day_time ASC")}
  scope :past_events, lambda {("events.day_time > #{Time.now}")}
  scope :in_range, lambda {where("(day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')")}
  scope :current_event, lambda {where("(day_time >= '#{(DateTime.now).to_s(:db)}') OR (end_time > '#{DateTime.now.to_s(:db)}')")}
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

  def createRecurrences(stopDay, excludeDays)
    excludeDays.each_with_index do |day, i|
      excludeDays[i] = Time.zone.parse(day)
       puts "excludeDays " +  excludeDays[i].to_s
    end
    start_time = self.day_time
    recurring_id = self.id


    nextWeekStart = self.day_time.advance(:weeks => 1)
    nextWeekEnd = self.end_time.advance(:weeks => 1)
    stop = Time.zone.parse(stopDay)
    while ((nextWeekStart != stop) && ( nextWeekStart < stop)) do
      puts "---------"
      puts "Start: " + "'" + nextWeekStart.to_s + "'"
      puts "STOP: " + "'" + stop.to_s + "'"
      nextWeekStart =  nextWeekStart.advance(:weeks => 1)
      nextWeekEnd =   nextWeekEnd.advance(:weeks => 1)
      if excludeDays.include?(nextWeekStart)
        #SKIP
        puts "SKIPPED"
      else
        event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id, :room_numbers => self.room_numbers ,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
        event.save
      end
      puts "---------"
    end
  end

  def swipe(event, id)
    message = Hash.new
    user = User.find_by(:gsw_id => id)
    if (user)
      if event.add_attendee(user)
        message[:message] = "Swiped"
      else
        message[:message] = "User already added event"
      end
    elsif (id == ";E?")
      message[:message] = "Error Swiping Card"
    else
      message[:message] = "User could not be found register at {URL} and then try again"
    end
    return message
  end
end


