class Admin::PermissionsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @permissions = Permission.order("#{sort_column} #{sort_direction}").where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
    @permissions = @permissions.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @permissions.count,
      iTotalDisplayRecords: @permissions.total_entries,
      aaData: data
    }
  end

private

  def data

    @permissions.map do |permission|
      {
        'DT_RowId' => permission.id.to_s,
        "permissions__id" => permission.id,
        "permissions__name" => permission.name.capitalize,
        "permissions__subject_class" => permission.subject_class,
        "permissions__action" => permission.action,
        "permissions__description" => truncate(permission.description, :length => 200, :separator => ' '),
        permission_actions: actions(permission)
      }
    end
  end

  def actions(permission)
    render(:partial=>"admin/permissions/actions.html.erb", locals: { permission: permission} , :formats => [:html])
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
    "name like :search or description like :search or subject_class like :search or action like :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end