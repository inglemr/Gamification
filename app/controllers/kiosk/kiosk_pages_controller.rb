class Kiosk::KioskPagesController < ApplicationController
  before_filter :authenticate_kiosk
  #load_and_authorize_resource :class => false
  #before_filter :load_permissions

  def index
    if current_host != nil
      redirect_to kiosk_main_path
    end
  end

  def swipe
    @event = Event.find(params[:event_id])
    if current_host.created_events.where("(events.day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND events.day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (events.end_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND events.end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')").where(:id => @event.id).first

    else
      flash[:alert] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def manage
    @event = Event.find(params[:event_id])
    if current_host.created_events.where("(events.day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND events.day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (events.end_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND events.end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')").where(:id => @event.id).first

    else
      flash[:alert] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def new_swipe
    @event = Event.find(params[:event_id])
    if current_host.created_events.where("(events.day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND events.day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (events.end_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND events.end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')").where(:id => @event.id).first
      if current_host.gsw_id != params[:id]
        message = @event.swipe(@event, params[:id])
        flash[:alert] = message[:message]
        redirect_to :back
      else
        redirect_to  kiosk_path(@event)
      end
    else
      flash[:alert] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def list_events
  	respond_to do |format|
    	format.html
    	format.json { render json: Kiosk::KioskEventsDatatable.new(view_context,current_host,current_kiosk.location_id,current_kiosk.room_id) }
  	end
  end

end
