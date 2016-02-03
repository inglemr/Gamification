class API::V1::UserController < ApplicationController
	load_and_authorize_resource :context => :admin, :class => false
	before_filter :load_permissions 
	protect_from_forgery except: :add_event

	def index
			puts params
	    @user = User.select(:id, :email, :username, :points, :events_attended).all
	    respond_to do |format|
	      format.json { render :json => @user }
	    end
  end

#Example Post Call
#{
#  "user":
#    {
#     "id": "1111"
#    },
#   "event": 
#    {
#     "id": "2"
#    }
#}
  def add_event
  		message = Hash.new
  		user = User.find_by(:gsw_id => params[:user][:id])
  		event = Event.find_by(:id => params[:event][:id])
  		if (user && event)
  			if event.add_attendee(user)
  				message[:success] = "Added Event"
	  			respond_to do |format|
		      	format.json { render :json => message.to_json }
		      end
		    else
		    	message[:error] = "User already added event"
		    	respond_to do |format|
		      	format.json { render :json => message.to_json }
		      end
	    	end
	    else
	    	message[:error] = "User or event could not be found"
	    	respond_to do |format|
	      	format.json { render :json => message.to_json }
	      end
	    end
  end
end
