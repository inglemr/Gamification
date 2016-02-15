class Admin::RoomsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view, location_id)
    @view = view
    @rooms = Room.order("#{sort_column} #{sort_direction}").where(:location_id => location_id).where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch]}%")
    @rooms = @rooms.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @rooms.count,
      iTotalDisplayRecords: @rooms.total_entries,
      aaData: data
    }
  end

private

  def data

    @rooms.map do |room|
      {
        'DT_RowId' => room.id.to_s,
        "rooms__room_number" => room.room_number,
        room_actions: actions(room)
      }
    end
  end

  def actions(room)
    render(:partial=>"admin/rooms/actions.html.erb", locals: { room: room} , :formats => [:html])
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
    "" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end

end






