class SettingsController < ApplicationController
	def settings
			@user = current_user
	end

	def updatesettings
		@user = current_user
		if params[:theme]
			@user.update_attributes(:theme => params[:theme])
		end
		if @user.save
  		redirect_to root_path, :flash => { :success => 'User was successfully updated.' }
		else
  		redirect_to settings_path, :flash => { :error => 'User was unsuccesfully updated.' }
		end
	end

	def updaterecords
		puts params
		puts "Testing"
		@user = current_user
		message = @user.update_records(params[:user][:gsw_pin])
		if message != "Success"
			flash[:alert] = message
		else
			flash[:success] = message
		end
		@user.save
		redirect_to settings_path
	end

end
