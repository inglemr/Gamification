class UsersDatatable
  delegate :params, :h, :link_to, :content_tag, :current_ability, :render, :can?, to: :@view
  
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
        link_to(user.id, user),
        user.email,
        user.created_at.to_formatted_s(:short),
        user.updated_at.to_formatted_s(:short),
        render(:partial=>"user/actions.html.erb", locals: { user: user} , :formats => [:html]) 

      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("email like :search or email like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[id email created_at updated_at]
    if params[:iSortCol_0]== "4"
      params[:iSortCol_0] = 0
    end
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end