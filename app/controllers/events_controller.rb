class EventsController < ApplicationController
	load_and_authorize_resource
	before_filter :load_permissions

	def show
		@event = Event.find(params[:id])
	end

	def my_points
		respond_to do |format|
    		format.html
    		format.json { render json: UserEventsDatatable.new(view_context, true) }
  	end
	end

	def index
		respond_to do |format|
    		format.html
    		format.json { render json: UserEventsDatatable.new(view_context, false) }
  	end
	end

  def manage
    @event = Event.find(params[:id])
    cols = params[:user_col]


    if current_user.created_events.include?(@event)
      respond_to do |format|
        format.html
        format.json { render json: Events::UserAttendanceDatatable.new(view_context, @event) }
        format.csv { send_data @event.attendees.to_csv(cols,@event) }
      end
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to :back
    end
  end

end
