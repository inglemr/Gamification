class Admin::UsersDatatable
  delegate :params, :content_tag, :current_ability ,:render, :can?, to: :@view
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        user.id,
        user.email,
        getRoles(user),
        user.points,
        user.created_at.to_formatted_s(:short),
        render(:partial=>"admin/user/actions.html.erb", locals: { user: user} , :formats => [:html]) 

      ]
    end
  end

  def getRoles(user)
    roles = ""
    user.roles.each do |role|
      roles += role.name + " "
    end
    return roles
  end
  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.joins(:roles).merge(User.where("email like :search or name like :search", search: "%#{params[:sSearch]}%"))
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id email role points]
    if params[:iSortCol_0]== "5"
      params[:iSortCol_0] = 0
    end
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end