class  ProfileDatatable
   delegate :params, :h, :current_user, :link_to, :show_events_path ,:content_tag, :datetime ,:current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view #.where('end_time >= ?', DateTime.now)
    @events = current_user.attended_events
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
        'DT_RowId' => event.id,
        "events__event_name" => getEventLink(event),
        "events__location_id" => Location.find(event.location_id).building_name,
        "events__point_val" => event.point_val
      }
    end
  end

  def getEventLink(event)
    link_to(show_events_path(event)) do
      content_tag(:span, event.event_name.capitalize, class: ["btn", "btn-default"])
    end

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






