class Admin::EventsDatatable
  delegate :params, :h,  :content_tag, :current_ability, :render, :can?, to: :@view
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Event.count,
      iTotalDisplayRecords: events.total_entries,
      aaData: data
    }
  end

private

  def data

    events.map do |event|
      [
        event.id,
        event.event_name.capitalize,
        event.description,
        event.location,
        event.point_val,
        event.day_time.strftime("%m/%d/%Y %I:%M %p"),
        render(:partial=>"admin/events/actions.html.erb", locals: { event: event} , :formats => [:html])
      ]
    end
  end

  def events
    @events ||= fetch_events
  end

  def fetch_events
    events = Event.order("#{sort_column} #{sort_direction}")
    events = events.page(page).per_page(per_page)
    if params[:sSearch].present?
      events = events.where("event_name like :search or description like :search", search: "%#{params[:sSearch]}%")
    end
    events
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id event_name description location point_val day_time actions]
    if params[:iSortCol_0]== "6"
      params[:iSortCol_0] = 0
    end
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end