class Kiosk::KioskPagesController < ApplicationController
  before_filter :authenticate_kiosk
  #load_and_authorize_resource :class => false
  #before_filter :load_permissions

  def swipe
    @event = Event.find(params[:event_id])
    if current_host.created_events.where(:id => @event.id).in_range.first || current_host.hosted_events.where(:id => @event.id).in_range.first

    else
      flash[:danger] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def generate_qrcodes
    @event = Event.find(params[:id])
    qrcode = RQRCode::QRCode.new(show_events_url(@event))
    svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 11)
    respond_to do |format|
      format.svg { render inline: svg}
    end
  end

  def manage
    @event = Event.find(params[:event_id])
    if current_host.created_events.where(:id => @event.id).in_range.first || current_host.hosted_events.where(:id => @event.id).in_range.first

    else
      flash[:danger] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def end_event
    puts "It worked!"
    @event = Event.find(params[:event_id])
    if current_host.created_events.where(:id => @event.id).in_range.first || current_host.hosted_events.where(:id => @event.id).in_range.first
      @event.end_time = DateTime.now.in_time_zone
      @event.save
      redirect_to kiosk_log_out_path
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end


  def new_swipe
    @event = Event.find(params[:event_id])
    id = params[:id]
    if(id.length > 15)
      id = id[4,9]
    end
    if current_host.created_events.where(:id => @event.id).in_range.first || current_host.hosted_events.where(:id => @event.id).in_range.first
      if current_host.gsw_id != id
        message = @event.swipe(@event, id)
        if message[:success]
          flash[:swiped] = message[:success]
        elsif message[:danger]
          flash[:danger] = message[:danger]
        end
        redirect_to :back
      else
        redirect_to  kiosk_manage_path(@event)
      end
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to kiosk_list_path
    end
  end

  def list_events
  	respond_to do |format|
    	format.html
    	format.json { render json: Kiosk::KioskEventsDatatable.new(view_context,current_host) }
  	end
  end

end
