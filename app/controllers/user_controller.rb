class UserController < ApplicationController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
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
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		params['user']['_roles'] ||= []
		params['user']['_roles'].each do |role|
  		@user.add_role role unless @user.has_role? role
  	end
  	puts "TEST"
	  Role.all.each do |role|
	  	if !params['user']['_roles'].include?(role.name)
	  		@user.remove_role role.name.to_sym
	  	end
		end
		if @user.update_attributes(params[:user].permit(:email, :username))
  		redirect_to user_path, :flash => { :success => 'User was successfully updated.' }
		else
  		redirect_to user_path, :flash => { :error => 'User was unsuccesfully updated.' }
		end
	end

	def delete
	end

end
