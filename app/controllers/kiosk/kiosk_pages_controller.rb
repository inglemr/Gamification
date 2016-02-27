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
    if current_host.created_events.where(:id => @event.id).in_range.first

    else
      flash[:alert] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
    require 'rqrcode'

    qrcode = RQRCode::QRCode.new(@event.description)
    image = qrcode.as_png
    svg = qrcode.as_svg
    html = qrcode.as_html
    string = qrcode.to_s

    qrcode = RQRCode::QRCode.new(@event.description)
    # With default options specified explicitly
    svg = qrcode.as_svg(offset: 0, color: '000', 
                        shape_rendering: 'crispEdges', 
                        module_size: 11)

    @qr = RQRCode::QRCode.new( admin_events_path, :size => 2, :level => :m )
  end

  def manage
    @event = Event.find(params[:event_id])
    if current_host.created_events.where(:id => @event.id).in_range.first

    else
      flash[:alert] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def new_swipe
    @event = Event.find(params[:event_id])
    if current_host.created_events.where(:id => @event.id).in_range.first
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
