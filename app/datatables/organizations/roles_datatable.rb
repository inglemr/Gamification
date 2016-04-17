class Organizations::RolesDatatable
   delegate :params, :h, :day, :datetime ,:content_tag, :current_ability,:current_user, :render, :can?,:truncate, to: :@view

  def initialize(view, organization)
    @view = view
    @roles = organization.org_roles#Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").upcoming_first.current_event#.past_events
    @roles = @roles.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @roles.count,
      iTotalDisplayRecords: @roles.total_entries,
      aaData: data
    }
  end

private

  def data
    @roles.map do |role|
      {
        DT_RowId: role.id.to_s,
        DT_RowClass: '',
        DT_RowAttr: '',
        "roles__name" => role.name,
        role_actions: actions(role)
      }
    end
  end

  def actions(role)
    render(:partial=>"organizations/role_actions.html.erb", locals: { role: role} , :formats => [:html])
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
    "name LIKE :search OR description LIKE :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end






