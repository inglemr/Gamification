class Admin::UserController  < Admin::BaseController
	load_and_authorize_resource
	before_filter :load_permissions 
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::UsersDatatable.new(view_context) }
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
		params['user']['_roles'].each do |id|
			if(!@user.roles.exists?(id))
  			@user.roles << Role.find(id)
  		end
  	end
	  Role.all.each do |role|
	  	if !(params['user']['_roles'].include?(role.id.to_s))
	  		@user.roles.delete(role.id)
	  	end
		end
		
		if @user.update_attributes(params[:user].permit(:email, :username))
  		redirect_to admin_user_path, :flash => { :success => 'User was successfully updated.' }
		else
  		redirect_to admin_user_path, :flash => { :error => 'User was unsuccesfully updated.' }
		end
	end

	def delete
	end
private
	def self.permission
	  return "Admin::User"
	end
end
