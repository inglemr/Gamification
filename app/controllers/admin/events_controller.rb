class Admin::EventsController < ApplicationController
load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  	end
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
		if @role.update_attributes(params[:role].permit(:name, :description))
  		redirect_to admin_role_path, :flash => { :success => 'Event was successfully updated.' }
		else
  		redirect_to admin_role_path, :flash => { :error => 'Event was unsuccesfully updated.' }
		end
	end

end
