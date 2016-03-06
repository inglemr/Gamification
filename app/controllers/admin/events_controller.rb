class Admin::EventsController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions 
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::EventsDatatable.new(view_context) }
  		end
	end

	def show
		@event = Event.find(params[:id])
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = Event.find(params[:id])
		@event.image = params[:image]
		if params[:event][:time] != ""
			time = params[:time]
			times = time.split.split("-")
			params[:event][:day_time] = times[0]
			params[:event][:day_time] = params[:event][:day_time][0] + " " + params[:event][:day_time][1] + " " + params[:event][:day_time][2]
			params[:event][:end_time] = times[1]
			params[:event][:end_time] = params[:event][:end_time][0] + " " + params[:event][:end_time][1] + " " + params[:event][:end_time][2]
			params[:event].delete :time
    	start_time_no_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
    	end_time_no_zone = DateTime.strptime(params[:event][:end_time], "%m/%d/%Y %I:%M %p")
			params[:event][:day_time] = Time.zone.parse(start_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
			params[:event][:end_time] = Time.zone.parse(end_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
    end
		if @event.update_attributes(event_params)
  		redirect_to admin_events_path, :flash => { :success => 'Event was successfully updated.' }
		else
  		redirect_to admin_events_path, :flash => { :error => 'Event was unsuccesfully updated.' }
		end
	end

	def new
		@event = Event.new
		@locations = Location.all.pluck(:building_name)
	end

	def create
		#Recurring Events
		recureInterval = params[:event_recure_intervals]
		recureDays = params[:event_days]
		recureEvent = params[:event_type]
		recureStop = []
		excludeEvent = "";
		if( recureEvent == "recure")
			excludeEvent = params[:exclude].split(",")
			recureStop = params[:recudeEndDate]
			recureStart = params[:recudeStartDate]
			start = recureStart + " " + params[:event][:day_time] + " EST"
			endT = recureStart + " " + params[:event][:end_time] + " EST"
			startTime = DateTime.parse(start)
			endTime = DateTime.parse(endT)
			params[:event][:day_time] = startTime
			params[:event][:end_time] = endTime
		else
			if params[:event][:time] != ""
				time = params[:time]
				times = time.split.split("-")
				params[:event][:day_time] = times[0]
				params[:event][:day_time] = params[:event][:day_time][0] + " " + params[:event][:day_time][1] + " " + params[:event][:day_time][2]
				params[:event][:end_time] = times[1]
				params[:event][:end_time] = params[:event][:end_time][0] + " " + params[:event][:end_time][1] + " " + params[:event][:end_time][2]
				params[:event].delete :time
	    	start_time_no_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
	    	end_time_no_zone = DateTime.strptime(params[:event][:end_time], "%m/%d/%Y %I:%M %p")
				params[:event][:day_time] = Time.zone.parse(start_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
				params[:event][:end_time] = Time.zone.parse(end_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
    	end
		end

		params[:event].delete(:recudeEndDate)
		params[:event].delete(:exclude)
		params[:event].delete(:recurring_id)

		# Room Numbers
		if params[:event][:room_numbers]
			params[:event][:room_numbers].delete("")
		end

		#Time parsing
		
    params[:event][:created_by] = current_user.id
    params[:event][:updated_by] = current_user.id
		@event = Event.new(event_params)
		@event.room_numbers << params[:event][:room_numbers]
		@event.image = params[:image]


		if @event.save
			if(recureEvent == "recure")
				@event.recurring_id = @event.id
				@event.createRecurrences(recureStop, excludeEvent, recureDays, recureInterval,recureStart)
				@event.save
			end
			if can? :show, Event, :context => :admin
  			redirect_to admin_event_path(@event), :flash => { :success => 'Event created successfully.' }
  		else
  			redirect_to root_path , :flash => { 'success' => 'Event created successfully.' }
  		end
  	else
  		render 'new'
  	end
	end

def destroy
  @event = Event.find(params[:id])
  @event.destroy
 
  redirect_to admin_events_path
end

private
  def event_params
    params.require(:event).permit(:room_numbers,:location_id,:end_time,:event_name, :department, :day_time, :point_val, :description, :created_by, :updated_by, :image)
  end

	def self.permission
	  return "Admin::Events"
	end


end
