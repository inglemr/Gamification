class SettingsController < ApplicationController
	def settings
			@user = current_user
	end

	def updatesettings
		@user = current_user
		if @user.update_attributes(params[:user].permit(:email, :username))
  		redirect_to root_path, :flash => { :success => 'User was successfully updated.' }
		else
  		redirect_to root_path, :flash => { :error => 'User was unsuccesfully updated.' }
		end
	end

end
