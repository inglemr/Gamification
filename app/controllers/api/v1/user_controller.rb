class API::V1::UserController < ApplicationController
	load_and_authorize_resource :context => :admin, :class => false
	before_filter :load_permissions 
	def index
			puts params
	    @user = User.select(:id, :email, :username, :points, :events_attended).all
	    respond_to do |format|
	      format.json { render :json => @user }
	    end
  end
end
