class Admin::RolesController < Admin::BaseController
	load_and_authorize_resource
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
		params['role']['_permissions'] ||= []
		params['role']['_permissions'].each do |id|
			if(!@role.permissions.exists?(id))
  			@role.permissions << Permission.find(id)
  		end
  	end
	  Permission.all.each do |permission|
	  	if !(params['role']['_permissions'].include?(permission.id.to_s)) && @role.permissions.exists?(permission.id)
	  		@role.permissions.delete(permission.id)
	  	end
		end

		if @role.update_attributes(params[:role].permit(:name, :description))
  		redirect_to admin_role_path, :flash => { :success => 'Role was successfully updated.' }
		else
  		redirect_to admin_role_path, :flash => { :error => 'Role was unsuccesfully updated.' }
		end
	end

private
	def self.permission
	  return "Admin::Roles"
	end

end
