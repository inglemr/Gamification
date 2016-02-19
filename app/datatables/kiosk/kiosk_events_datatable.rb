class Kiosk::KioskEventsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view, current_host, location_id, room_number)
    @view = view
    @events = current_host.created_events.where("(events.day_time >= '#{(Time.now - (2 * 60 * 60)).to_s(:db)}' AND events.day_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}') OR (events.end_time <= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}' AND events.end_time >= '#{(Time.now + (2 * 60 * 60)).to_s(:db)}')")
    @events = @events.page(page).per_page(per_page)
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @events.count,
      iTotalDisplayRecords: @events.total_entries,
      aaData: data
    }
  end

private

  def data
    @events.map do |event|
      {
        DT_RowId: event.id.to_s,
        DT_RowClass: '',
        DT_RowAttr: '',
        "events__id" => event.id,
        "events__event_name" => event.event_name,
        "events__description" => truncate(event.description, :length => 200, :separator => ' '),
        "events__location_id" => event.location_id,
        "events__point_val" => event.point_val,
        events_eventTile: eventTile(event),
        "events__day_time" => event.day_time.to_formatted_s(:short)
      }
    end
  end
  
  def eventTile(event)
    render(:partial=>"kiosk/kiosk_pages/tile.html.erb", locals: { event: event},:formats => [:html])
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0? params[:iDisplayLength].to_i : 10
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def search_string
    "event_name LIKE :search OR description LIKE :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end 






