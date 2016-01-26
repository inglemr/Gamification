class API::V1::UserController < ApplicationController
	def index
	    @user = User.select(:id, :email, :username, :points, :events_attended).all
	    respond_to do |format|
	      format.json { render :json => @user }
	    end
  end
end
