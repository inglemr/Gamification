class Admin::RolesDatatable
  delegate :params, :h,  :content_tag, :current_ability, :render, :can?, to: :@view
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Role.count,
      iTotalDisplayRecords: roles.total_entries,
      aaData: data
    }
  end

private

  def data

    roles.map do |role|
      [
        role.id,
        role.name.capitalize,
        role.description,
        render(:partial=>"admin/roles/actions.html.erb", locals: { role: role} , :formats => [:html])
      ]
    end
  end

  def roles
    @roles ||= fetch_roles
  end

  def fetch_roles
    roles = Role.order("#{sort_column} #{sort_direction}")
    roles = roles.page(page).per_page(per_page)
    if params[:sSearch].present?
      roles = roles.where("name like :search or description like :search", search: "%#{params[:sSearch]}%")
    end
    roles
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name description actions]
    if params[:iSortCol_0]== "4"
      params[:iSortCol_0] = 0
    end
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end