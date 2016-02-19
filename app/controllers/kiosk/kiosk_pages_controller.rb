class Kiosk::KioskPagesController < ApplicationController
  before_filter :authenticate_kiosk
  #load_and_authorize_resource :class => false
  #before_filter :load_permissions

  def index
    if current_host != nil
      redirect_to main_path
    end
  end

  def swipe
    @event = Event.find(params[:event_id])
  end

  def manage
    @event = Event.find(params[:event_id])
  end

  def new_swipe
    flash[:alert] = "Swiped"
    redirect_to :back
  end

  def main
  	user = User.find_by(:id => params[:pin])
  	if current_host == nil && user == nil
  		flash[:alert] = 'Invalid PIN'
  		redirect_to :back
  	else
  		session[:current_host] ||= user.id
  	end

  end

  def list_events

  	respond_to do |format|
    	format.html
    	format.json { render json: Kiosk::KioskEventsDatatable.new(view_context,current_host,current_kiosk.location_id,current_kiosk.room_id) }
  	end
  end

end
