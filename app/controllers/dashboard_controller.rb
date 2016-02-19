class DashboardController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false
  before_filter :load_permissions
  def index
  	respond_to do |format|
    	format.html
    	format.json { render json: EventsDatatable.new(view_context) }
  	end
  end

  def cal_events
  	@events = Event.where('end_time >= ?', DateTime.now).upcoming_first#.past_events
  	array = Array.new

  	@events.each do |event|
  		color = "%06x" % (event.id * 0xffffff)
  		output = Hash.new
  		output[:title] = event.event_name
  		output[:start] = event.day_time.to_s(:calendar)
  		output[:end] = event.end_time.to_s(:calendar)
  		output[:url] = url_for(:controller => 'events',:action => 'show', :id => event.id)
  		output[:color] = color
  		output[:textColor] = "white"
  		classArray = Array.new 
  		classArray << "event"
      classArray << "bg-color-greenLight"
  		output[:className] = classArray
  		array << output
  	end
	  respond_to do |format|
	    format.json { render :json => array }
	  end
  end
    
end
