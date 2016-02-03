class Admin::RolesController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions 
	
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
		params['role']['permission_ids'] ||= []
		params['role']['permission_ids'].each do |id|
			if(!@role.permissions.exists?(id) && !id.blank?)
  			@role.permissions << Permission.find(id)
  		end
  	end
	  Permission.all.each do |permission|
	  	if !(params['role']['permission_ids'].include?(permission.id.to_s)) && @role.permissions.exists?(permission.id)
	  		@role.permissions.delete(permission.id)
	  	end
		end

		if @role.update_attributes(role_params)
  		redirect_to admin_role_path, :flash => { :success => 'Role was successfully updated.' }
		else
  		redirect_to admin_role_path, :flash => { :error => 'Role was unsuccesfully updated.' }
		end
	end

	def destroy
	  @role = Role.find(params[:id])
	  @role.destroy
	  redirect_to admin_roles_path
	end

	def new
		@role = Role.new
	end

	def create
		@role = Role.new(role_params)
		params['role']['permissions'] ||= []
		params['role']['permissions'].each do |id|
			if(!@role.permissions.exists?(id))
  			@role.permissions << Permission.find(id)
  		end
  	end
	  Permission.all.each do |permission|
	  	if !(params['role']['permissions'].include?(permission.id.to_s)) && @role.permissions.exists?(permission.id)
	  		@role.permissions.delete(permission.id)
	  	end
		end

		if @role.save
  		redirect_to admin_role_path(@role)
  	else
  		render 'new'
  	end
	end




private
	def self.permission
	  return "Admin::Roles"
	end

  def role_params
    params.require(:role).permit(:name, :description, :permissions)
  end

end
