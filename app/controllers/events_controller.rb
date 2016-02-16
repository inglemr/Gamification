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

end
