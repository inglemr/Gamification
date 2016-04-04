class Admin::LocationEventsDatatable
   delegate :params, :h,  :content_tag, :datetime, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view,location_id)
    @view = view
    @events = Event.order("#{sort_column} #{sort_direction}").where('day_time >= ?', DateTime.now).where(:location_id => location_id).where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
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
        'DT_RowId' => event.id.to_s,
        "events__id" => event.id,
        "events__event_name" => event.event_name.capitalize,
        "events__description" => truncate(event.description, :length => 20, :separator => ' '),
        "events__location_id" => Location.find(event.location_id).building_name,
        "events__point_val" => event.point_val,
        "events__created_by" => User.find(event.created_by).username,
        "events__updated_by" => User.find(event.updated_by).username,
        events_room: event_rooms(event.rooms),
        events_time: event.day_time.to_formatted_s(:short) +  " - " + event.end_time.to_formatted_s(:short),
        event_actions: actions(event)
      }
    end
  end

  def event_rooms(rooms)
    string = ""
    rooms.each do |room|
      strin += room.room_number + " "
    end
    return string
  end

  def actions(event)
    render(:partial=>"admin/events/actions.html.erb", locals: { event: event} , :formats => [:html])
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






