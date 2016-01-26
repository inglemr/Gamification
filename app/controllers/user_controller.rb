class UserController < ApplicationController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to , :alert => exception.message
  	end
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: UsersDatatable.new(view_context) }
  		end
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
	end

	def delete
	end

end
