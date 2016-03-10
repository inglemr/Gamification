class SettingsController < ApplicationController
	def settings
			@user = current_user
	end

	def updatesettings
		@user = current_user
		puts params
		if params[:theme]
			@user.update_attributes(:theme => params[:theme])
		end
		if @user.save
  		redirect_to root_path, :flash => { :success => 'User was successfully updated.' }
		else
  		redirect_to root_path, :flash => { :error => 'User was unsuccesfully updated.' }
		end
	end

end
