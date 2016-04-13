class Event < ActiveRecord::Base

	validates :day_time, presence: true
  validates :end_time, presence: true
  validates :location_id, presence: true
  validates :rooms, presence: true
  validates :point_val, presence: true
  belongs_to :users
  has_and_belongs_to_many :rooms
  has_many :user_events, foreign_key: :attended_event_id
  has_many :attendees, through: :user_events, dependent: :destroy
  has_many :host_events, foreign_key: :hosted_event_id
  has_many :hosts, through: :host_events, dependent: :destroy
  has_one :location, foreign_key: :location_id
  mount_uploader :image, ImageUploader

  scope :latest_first , lambda { order("events.day_time DESC")}
  scope :upcoming_first , lambda { order("events.day_time ASC")}
  scope :past_events, lambda {("events.day_time > #{Time.now}")}
  scope :in_range, lambda {where("(day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')")}
  scope :current_event, lambda {where("(day_time >= '#{(DateTime.now).to_s(:db)}') OR (end_time > '#{DateTime.now.to_s(:db)}')")}

  def add_attendee(user)
  	if !user.attended_events.all.include?(self)
  		self.attendees << user
      user.points = user.points.to_f + self.point_val.to_f
      user.save
  		self.save
  		true
  	else
  		false
  	end
  end

  def add_host(user)
    if !user.hosted_events.all.include?(self) && User.find(self.created_by) != user
      self.hosts << user
      user.save
      self.save
      true
    else
      false
    end
  end

  def remove_host(user)
    if user.hosted_events.all.include?(self)
      self.hosts.delete(user)
      user.save
      self.save
      true
    else
      false
    end
  end

  def add_room(room_id)
    room = Room.find(room_id)
    if !room.events.all.include?(self)
      self.rooms << room
      room.save
      self.save
      true
    else
      false
    end
  end

  def remove_room(room_id)
    room = Room.find(room_id)
    if room.events.all.include?(self)
      self.rooms.delete(room)
      room.save
      self.save
      true
    else
      false
    end
  end

  def date_of_next(current_date,day)
    date  = DateTime.parse(day + " " + current_date.hour.to_s + ":" + current_date.min.to_s + " " + current_date.zone)
    delta = date > Date.today ? 0 : 7
    future = date + delta.days
  end

  def createRecurrences(stopDay, excludeDays, recureDays, recureInterval, recureStart)
    recureIntervals = Hash.new
    recureIntervals["W"] = "Weekly"
    recureIntervals["BiW"] = "Bi-Weekly"
    recureIntervals["D"] = "Daily"
    recureIntervals["M"] = "Monthly"

    days = Hash.new
    days["SU"] = "Sunday"
    days["M"] = "Monday"
    days["T"] = "Tuesday"
    days["W"] = "Wednesday"
    days["TH"] = "Thursday"
    days["F"] = "Friday"
    days["S"] = "Saturday"

    daysInNum = Hash.new
    daysInNum[0] = "Sunday"
    daysInNum[1] = "Monday"
    daysInNum[2] = "Tuesday"
    daysInNum[3] = "Wednesday"
    daysInNum[4] = "Thursday"
    daysInNum[5] = "Friday"
    daysInNum[6] = "Saturday"

    recureOnDays = Array.new
    recureDays.each do |day|
      recureOnDays << days[day]
    end

    recureInterval = recureIntervals[recureInterval]

    excludeDays.each_with_index do |day, i|
      excludeDays[i] = Time.zone.parse(day)
    end
    start_time = self.day_time
    recurring_id = self.id

    eventsToRecure = Array.new
    recureOnDays.each do |day|
      nextWeekStart = date_of_next(self.day_time, day)
      nextWeekEnd = date_of_next(self.end_time, day)
      event = Event.new
      if( nextWeekStart == self.day_time)
        event = self
      else
        puts "Tiny Stew"
        puts nextWeekStart
        event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id ,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
        event.rooms << self.rooms
        event.save
      end
      eventsToRecure << event
    end


    if(recureInterval == "Weekly")
      eventsToRecure.each do |event|
        nextWeekStart = event.day_time.advance(:weeks => 1)
        nextWeekEnd = event.end_time.advance(:weeks => 1)
        stop = Time.zone.parse(stopDay)
        while ((nextWeekStart != stop) && ( nextWeekStart < stop)) do
          if !excludeDays.include?(nextWeekStart)
            puts "Tiny Moo"
            puts nextWeekStart
            event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id ,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
            event.rooms << self.rooms
            event.save
          end
          nextWeekStart =  nextWeekStart.advance(:weeks => 1)
          nextWeekEnd =   nextWeekEnd.advance(:weeks => 1)
        end
      end
    elsif(recureInterval == "Bi-Weekly")
      eventsToRecure.each do |event|
        nextWeekStart = event.day_time.advance(:weeks => 2)
        nextWeekEnd = event.end_time.advance(:weeks => 2)
        stop = Time.zone.parse(stopDay)
        while ((nextWeekStart != stop) && ( nextWeekStart < stop)) do
          if !excludeDays.include?(nextWeekStart)
            event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id ,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
            event.rooms << self.rooms
            event.save
          end
          nextWeekStart =  nextWeekStart.advance(:weeks => 2)
          nextWeekEnd =   nextWeekEnd.advance(:weeks => 2)
        end
      end
    elsif(recureInterval == "Monthly")
      eventsToRecure.each do |event|
        nextWeekStart = event.day_time + 1.month
        nextWeekEnd = event.end_time + 1.month
        stop = Time.zone.parse(stopDay)
        while ((nextWeekStart != stop) && ( nextWeekStart < stop)) do
          if !excludeDays.include?(nextWeekStart)
            event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
            event.rooms << self.rooms
            event.save
          end
          nextWeekStart =  nextWeekStart + 1.month
          nextWeekEnd =   nextWeekEnd + 1.month
        end
      end
    elsif(recureInterval == "Daily")
      eventsToRecure.each do |event|
        nextWeekStart = event.day_time.advance(:days => 1)
        nextWeekEnd = event.end_time.advance(:days => 1)
        stop = Time.zone.parse(stopDay)
        while ((nextWeekStart != stop) && ( nextWeekStart < stop)) do
          if !excludeDays.include?(nextWeekStart)
            event = Event.new(:created_by => self.created_by, :updated_by => self.updated_by ,:event_name => self.event_name , :department => self.department, :point_val => self.point_val, :location_id => self.location_id ,:description => self.description , :day_time => nextWeekStart, :end_time => nextWeekEnd,:recurring_id => recurring_id)
            event.rooms << self.rooms
            event.save
          end
          nextWeekStart =  nextWeekStart.advance(:days => 1)
          nextWeekEnd =   nextWeekEnd.advance(:days => 1)
        end
      end
    end
  end

  def swipe(event, id)
    message = Hash.new
    user = User.find_by(:gsw_id => id)
    if (user)
      if event.add_attendee(user)
        message[:success] = "Swiped"
      else
        message[:danger] = "User already added event"
      end
    elsif (id == ";E?")
      message[:danger] = "Error Swiping Card"
    else
      if(SavedSwipe.where(:gsw_id => id, :event_id => event.id).size > 0)
        message[:danger] = "GSW ID already linked to event please register at {URL} to claim your points"
      else
        swipe = SavedSwipe.new(:gsw_id => id, :event_id => event.id)
        swipe.save
        message[:success] = "GSW ID linked to event. Please register at {URL} to claim your points"
      end

    end
    return message
  end
end


