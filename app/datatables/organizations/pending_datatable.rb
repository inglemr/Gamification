class Organizations::PendingDatatable
   delegate :params, :h, :day, :datetime ,:content_tag, :current_ability,:current_user, :render, :can?,:truncate, to: :@view

  def initialize(view, organization)
    @organization = organization
    @view = view
    @pending = Request.where(:organization_id => @organization.id, :status => "open")#Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").upcoming_first.current_event#.past_events
    @pending = @pending.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @pending.count,
      iTotalDisplayRecords: @pending.total_entries,
      aaData: data
    }
  end

private

  def data
    @pending.map do |request|
      {
        DT_RowId: request.id.to_s,
        DT_RowClass: '',
        DT_RowAttr: '',
        "users__email" => User.find(request.user_id).email,
        "users__username" => User.find(request.user_id).username,
        user_actions: actions(User.find(request.user_id),request)
      }
    end
  end


  def actions(member,request)
    render(:partial=>"organizations/pending_member_actions.html.erb", locals: { member: member, organization: @organization, request: request} , :formats => [:html])
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






