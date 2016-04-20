class Admin::RoomsController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions


	def new
	    @room = Room.new
	    @location = Location.find(params[:room][:location_id])
	    respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @room }
	      format.js
	    end
	  end

	def create
	    @room = Room.new(room_params)
	    puts params
	    @location = Location.find(params[:room][:location_id])
	    respond_to do |format|
	      if @room.save
	      	@location.rooms_count = @location.rooms_count + 1
	      	@location.save
	        format.html { redirect_to @event.timeline, notice: 'Room Number was successfully created.' }
	        format.json { render json: @room, status: :created, location: @room }
	        format.js{}
	      else
	        format.html { render action: "new" }
	        format.json { render json: @room.errors, status: :unprocessable_entity }
	        format.js {}
	      end
	    end
	end
	def destroy
	  @room = Room.find(params[:id])
	  @location = Location.find(@room.location_id)
	  @location.rooms_count = @location.rooms_count - 1
	  @location.save
	  @room.destroy
	  redirect_to :back
	end

private

	def room_params
		params.require(:room).permit(:room_number, :location_id)
	end
end
