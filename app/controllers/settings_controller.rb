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
  		@message = 'User was successfully updated.'
		else
			@message = "User was unsuccesfully updated."
		end
		respond_to do |format|
			format.js   { render 'settings.js.erb'}
			format.html { redirect_to(:action => 'settings', :flash => { :error => @message })}
		end
	end

	def updaterecords
		@user = current_user
		@message = @user.update_records(params[:user][:gsw_pin])
		@form_type = "records"
		@user.save
		respond_to do |format|
			format.js   { render 'settings.js.erb'}
		end

	end

end
