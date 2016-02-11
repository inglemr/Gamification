class Admin::LocationsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @locations = Location.select('distinct building_name, *')
    @locations = @locations.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @locations.count,
      iTotalDisplayRecords: @locations.total_entries,
      aaData: data
    }
  end

private

  def data

    @locations.map do |location|
      {
        'DT_RowId' => location.id.to_s,
        "locations__id" => location.id,
        "locations__building_name" => location.building_name.capitalize,
        "locations__room_number" => location.room_number,
        location_actions: actions(location)
      }
    end
  end

  def actions(location)
    render(:partial=>"admin/location/actions.html.erb", locals: { location: location} , :formats => [:html])
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
    "building_name LIKE :search OR room_number LIKE :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end

  def select_statement
    ""
  end
end






