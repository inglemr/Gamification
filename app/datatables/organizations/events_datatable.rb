class Organizations::EventsDatatable
   delegate :params, :h, :day, :datetime ,:content_tag, :current_ability,:current_user, :render, :can?,:truncate, to: :@view

  def initialize(view, organization)
    @view = view
    @events = organization.events#Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").upcoming_first.current_event#.past_events
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
        "events__event_name" => event.event_name,
        "events__location_id" => Location.find(event.location_id).building_name,
        "events__point_val" => event.point_val,
        "events__day_time" => event.day_time.to_formatted_s(:short),
        event_actions: actions(event)
      }
    end
  end

  def actions(event)
    render(:partial=>"organizations/event_actions.html.erb", locals: { event: event} , :formats => [:html])
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0? params[:iDisplayLength].to_i : 4
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def search_string
    "username LIKE :search OR description LIKE :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end






