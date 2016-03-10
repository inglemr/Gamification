class EventsController < ApplicationController
	load_and_authorize_resource :except => [:show]
   protect_from_forgery except: :csv
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
    @event = current_user.created_events.first;
    if (params[:event_id])
      temp = Event.find(params[:event_id])
      if( current_user.created_events.include?(temp))
        @event = temp
        render(:index, locals: { event: @event} , :formats => [:js])
      else
        flash[:danger] = "Unauthorized"
      end
    else
		respond_to do |format|
    		format.html
        format.js
    		format.json { render json: UserEventsDatatable.new(view_context, false) }
  	end
  end
	end

  def csv
    cols = params[:user_col]
    @event = Event.find(params[:id])
     if( current_user.created_events.include?(@event))
        respond_to do |format|
          format.html {}
          format.js   {}
          format.csv do
            response.header['Content-Disposition'] = 'attachment; filename="' + Time.now.strftime("%Y%m%d%H%M") + '_' + @event.event_name.to_s + '_attendance.csv'
            render text: @event.attendees.to_csv(cols,@event)
          end
        end
      else
        flash[:danger] = "Unauthorized"
        respond_to do |format|
          format.json
        end
      end
  end

  def manage
    @event = Event.find(params[:id])
    if current_user.created_events.include?(@event)
      respond_to do |format|
        format.html
        format.json { render json: Events::UserAttendanceDatatable.new(view_context, @event) }
      end
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to events_path
    end
  end

end
