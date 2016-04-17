class Organizations::RosterDatatable
   delegate :params, :h, :day, :datetime ,:content_tag, :current_ability,:current_user, :render, :can?,:truncate, to: :@view

  def initialize(view, organization)
    @view = view
    @roster = organization.users#Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").upcoming_first.current_event#.past_events
    @roster = @roster.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @roster.count,
      iTotalDisplayRecords: @roster.total_entries,
      aaData: data
    }
  end

private

  def data
    @roster.map do |member|
      {
        DT_RowId: member.id.to_s,
        DT_RowClass: '',
        DT_RowAttr: '',
        "users__email" => member.email,
        "users__org_roles" => getRoles(member),
        user_actions: actions(member)
      }
    end
  end

  def getRoles(member)
    test = ""
    member.org_roles.each do |role|
      test += "<span class='badge'>" +role.name.to_s + "</span> "
    end

    return test.html_safe
  end

  def actions(member)
    render(:partial=>"organizations/member_actions.html.erb", locals: { member: member} , :formats => [:html])
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
    "username LIKE :search OR description LIKE :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end






