class Admin::KiosksController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions
	skip_before_filter :require_no_authentication
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::KiosksDatatable.new(view_context) }
  		end
	end

	def destroy
	  @kiosk = Kiosk.find(params[:id])
	  @kiosk.destroy
	  redirect_to admin_kiosks_path
	end

	def show
		@kiosk = Kiosk.find(params[:id])
	end

	def edit
		@kiosk = Kiosk.find(params[:id])
	end

	def update
		@kiosk = Kiosk.find(params[:id])
		
		if @kiosk.update_attributes(kiosk_params)
  		redirect_to admin_kiosk_path, :flash => { :success => 'Kiosk was successfully updated.' }
		else
  		redirect_to admin_kiosk_path, :flash => { :error => 'Kiosk was unsuccesfully updated.' }
		end
	end


	def new
		@kiosk = Kiosk.new
	end

	def create
		@kiosk = Kiosk.new(kiosk_params)
		if @kiosk.save
  		redirect_to admin_kiosks_path
  	else
  		render "new"
  	end
	end



private
 def kiosk_params
    params.require(:kiosk).permit(:password, :password_confirmation,:room_id,:location_id,:kiosk_name)
  end

	def self.permission
	  return "Admin::Kiosk"
	end
end
