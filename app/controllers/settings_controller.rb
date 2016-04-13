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
		@user = current_user
		@message = @user.update_records(params[:user][:gsw_pin])

		@user.save
		respond_to do |format|
			format.js   { render 'settings.js.erb'}
		end

	end

end
