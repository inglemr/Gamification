class KioskPagesController < ApplicationController
  before_filter :authenticate_kiosk!
  #load_and_authorize_resource :class => false
  #before_filter :load_permissions

  def index

  end

  def main
  	user = User.find_by(:id => params[:pin])
  	if user == nil
  		flash[:alert] = 'Invalid PIN'
  		redirect_to :back
  	else
  		session[:current_host] = user
  	end

  end

  def list_events
  	respond_to do |format|
    	format.html
    	format.json { render json: EventsDatatable.new(view_context) }
  	end
  end

end
