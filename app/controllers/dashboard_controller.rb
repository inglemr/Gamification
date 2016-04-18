class DashboardController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false
  before_filter :load_permissions
  def index
    Resque.enqueue(Test)
    @userLeader = User.where(:class_type => current_user.class_type).order("points DESC").limit(5)
    @freshmen = User.where(:class_type => "Freshmen").order("points DESC").limit(5)
    @sophmore = User.where(:class_type => "Sophmore").order("points DESC").limit(5)
    @junior = User.where(:class_type => "Junior").order("points DESC").limit(5)
    @senior = User.where(:class_type => "Senior").order("points DESC").limit(5)
    @all = User.all.order("points DESC").limit(5)
  	respond_to do |format|
    	format.html
    	format.json { render json: EventsDatatable.new(view_context) }
  	end
  end




  def cal_events
  	@events = Event.where('end_time >= ?', DateTime.now).upcoming_first#.past_events
    #NOTE This is just for demo
  	array = Array.new
    colorArray = Array.new
    colorArray << "bg-color-blue"
    colorArray << "bg-color-blueLight"
    colorArray << "bg-color-blueDark"
    colorArray << "bg-color-green"
    colorArray << "bg-color-greenLight"
    colorArray << "bg-color-red"
    colorArray << "bg-color-yellow"
    colorArray << "bg-color-orange"
    colorArray << "bg-color-orangeDark"
    colorArray << "bg-color-pink"
    colorArray << "bg-color-pinkDark"
    colorArray << "bg-color-purple"
    colorArray << "bg-color-lighten"
    colorArray << "bg-color-white"
    colorArray << "bg-color-grayDark"
    colorArray << "bg-color-magenta"
    colorArray << "bg-color-teal"
    colorArray << "bg-color-redLight"

  	@events.each do |event|
  		output = Hash.new
      classArray = Array.new
      classArray << "event"
      classArray << colorArray[rand(0..19)]

  		output[:title] = event.event_name
  		output[:start] = event.day_time.to_s(:calendar)
  		output[:end] = event.end_time.to_s(:calendar)
  		output[:url] = url_for(:controller => 'events',:action => 'show', :id => event.id)
  		output[:className] = classArray
  		array << output
  	end
	  respond_to do |format|
	    format.json { render :json => array }
	  end
  end

end
