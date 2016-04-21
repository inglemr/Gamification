class Admin::PermissionsController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::PermissionsDatatable.new(view_context) }
  		end
	end

	def show
		@permission = Permission.find(params[:id])
	end

	def edit
		@permission = Permission.find(params[:id])
	end

	def update
		@permission = Permission.find(params[:id])
		if @permission.update_attributes(permission_params)
  		redirect_to admin_permissions_path, :flash => { :success => 'Permission was successfully updated.' }
		else
  		redirect_to admin_permissions_path, :flash => { :error => 'Permission was unsuccesfully updated.' }
		end
	end

	def new
		@permission = Permission.new
	end

	def create
		@permission = Permission.new(permission_params)
		if @permission.save
  		redirect_to admin_permission_path(@permission)
  	else
  		render 'new'
  	end
	end

def destroy
  @permission = Permission.find(params[:id])
  @permission.destroy
  redirect_to admin_events_path
end

private
  def permission_params
    params.require(:permission).permit(:name, :subject_class, :description, :action, :scope)
  end
end
