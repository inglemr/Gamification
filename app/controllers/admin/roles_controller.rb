class Admin::RolesController < ApplicationController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  	end
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::RolesDatatable.new(view_context) }
  		end
	end

	def show
		@role = Role.find(params[:id])
	end

	def edit
		@role = Role.find(params[:id])
	end

	def update
		@role = Role.find(params[:id])
		if @role.update_attributes(params[:role].permit(:name, :description))
  		redirect_to admin_role_path, :flash => { :success => 'Role was successfully updated.' }
		else
  		redirect_to admin_role_path, :flash => { :error => 'Role was unsuccesfully updated.' }
		end
	end

end
