class Admin::LocationController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions

	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::LocationsDatatable.new(view_context) }
  		end
	end

	def show
		@location = Location.find(params[:id])
	end

	def edit
		@location = Location.find(params[:id])
	end

	def update
		@location = Location.find(params[:id])
		if @location.update_attributes(location_params)
  		redirect_to admin_location_path, :flash => { :success => 'Location was successfully updated.' }
		else
  		redirect_to admin_location_path, :flash => { :error => 'Location was unsuccesfully updated.' }
		end
	end

	def new
		@location = Location.new
	end

	def create
		@location = Location.new(location_params)
		if @location.save
			if can? :show, Location, :context => :admin
  			redirect_to admin_location_path(@location), :flash => { :success => 'Location created successfully.' }
  		else
  			redirect_to root_path , :flash => { 'success' => 'Location created successfully.' }
  		end
  	else
  		render 'new'
  	end
	end

	def destroy
		@location = Location.find(params[:id])
  	@location.destroy
 
  	redirect_to admin_location_index_path
	end

	private
  def location_params
    params.require(:location).permit(:building_name, :room_number)
  end

	def self.permission
	  return "Admin::Events"
	end

end
