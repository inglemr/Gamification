class SettingsController < ApplicationController
	def settings
			@user = current_user
			@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id).where(trackable_type: "Event").limit(3)

			respond_to do |format|
				format.html {}
				format.json {render json: ProfileDatatable.new(view_context)}
			end
	end

	def updatesettings
		@user = current_user
		prev_theme = @user.theme

		@user.update_attributes(:theme => params[:theme])
		if prev_theme == @user.theme
			@theme_change = false
		end
		not_setings = params[:user][:notification_settings]
		@user.notification_settings = not_setings
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
