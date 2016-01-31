class Admin::RolesDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @roles = Role.order("#{sort_column} #{sort_direction}").where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
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
        'DT_RowId' => role.id.to_s,
        "roles__id" => role.id,
        "roles__name" => role.name.capitalize,
        "roles__description" => truncate(role.description, :length => 200, :separator => ' '),
        role_actions: actions(role)
      }
    end
  end

  def actions(role)
    render(:partial=>"admin/roles/actions.html.erb", locals: { role: role} , :formats => [:html])
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
    "name like :search or description like :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end