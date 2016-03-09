class Events::UserAttendanceDatatable
  delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view, event)
    @view = view
    @event = event
    @users = User.order("#{sort_column} #{sort_direction}").joins(:user_events).where("user_events.attended_event_id = '#{event.id}'").where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
    @users = @users.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @users.count,
      iTotalDisplayRecords: @users.total_entries,
      aaData: data
    }
  end

private

  def data

    @users.map do |user|
      {
        'DT_RowId' => user.id.to_s,
        "users__gsw_id" => user.gsw_id,
        "users__name" => user.name,
        "users__email" => user.email,
        "users__name" => user.name,
        "users__class_type" => user.class_type,
        "users_events__created_at" => getTime(user.id).to_s(:short)
      }
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
    "email like :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end

  def getTime(userid)
    User.find_by_sql("SELECT users.id, user_events.created_at FROM users INNER JOIN user_events ON users.id = user_events.attendee_id WHERE users.id='#{userid}' AND user_events.attended_event_id='#{@event.id}'").first.created_at
  end

end






