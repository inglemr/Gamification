class Admin::EventsController < Admin::BaseController
	load_and_authorize_resource
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
		if params[:event][:day_time] != ""
    	without_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
			params[:event][:day_time] = Time.zone.parse(without_zone.strftime('%Y-%m-%d %H:%M:%S'))
    end
		if @event.update_attributes(event_params)
  		redirect_to admin_events_path, :flash => { :success => 'Event was successfully updated.' }
		else
  		redirect_to admin_events_path, :flash => { :error => 'Event was unsuccesfully updated.' }
		end
	end

	def new
		@event = Event.new
	end

	def create
		if params[:event][:day_time] != ""
    	without_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
			params[:event][:day_time] = Time.zone.parse(without_zone.strftime('%Y-%m-%d %H:%M:%S'))
    end
    params[:event][:created_by] = current_user.id
    params[:event][:updated_by] = current_user.id
		@event = Event.new(event_params)
		@event.image = params[:image]
		if @event.save
  		redirect_to admin_event_path(@event)
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
    params.require(:event).permit(:event_name, :department, :day_time, :location, :point_val, :description, :created_by, :updated_by, :image)
  end

	def self.permission
	  return "Admin::Events"
	end


end
