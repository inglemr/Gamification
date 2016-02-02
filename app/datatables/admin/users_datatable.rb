class Admin::UsersDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @users = User.order("#{sort_column} #{sort_direction}").joins(:roles).select(select_statement).where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
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
        "users__id" => user.id,
        "users__email" => user.email,
        "roles__name" => user.roles.pluck(:name),
        "users__points" => user.points,
        "users__created_at" => user.created_at.to_formatted_s(:short),
        user_actions: actions(user)
      }
    end
  end

  def actions(user)
    render(:partial=>"admin/user/actions.html.erb", locals: { user: user} , :formats => [:html]) 
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
    "email like :search or roles.name like :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end

  def select_statement
    "DISTINCT users.*"
  end

end


  