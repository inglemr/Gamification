class Admin::KioskController < ApplicationController
	load_and_authorize_resource :context => :admin
	before_filter :load_permissions 
	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::KiosksDatatable.new(view_context) }
  		end
	end

	def show
		@kiosk = Kiosk.find(params[:id])
	end

	def edit
		@kiosk = Kiosk.find(params[:id])
	end

	def update
		@kiosk = Kiosk.find(params[:id])
		
		if @Kiosk.update_attributes(params[:Kiosk].permit(:kiosk_name))
  		redirect_to admin_kiosk_path, :flash => { :success => 'Kiosk was successfully updated.' }
		else
  		redirect_to admin_kiosk_path, :flash => { :error => 'Kiosk was unsuccesfully updated.' }
		end
	end

	def delete
	end
private
	def self.permission
	  return "Admin::Kiosk"
	end
end
