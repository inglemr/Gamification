class Admin::OrganizationsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @organizations = Organization.order("#{sort_column} #{sort_direction}").where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
    @organizations = @organizations.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @organizations.count,
      iTotalDisplayRecords: @organizations.total_entries,
      aaData: data
    }
  end

private

  def data

    @organizations.map do |organization|
      {
        'DT_RowId' => organization.id.to_s,
        "organizations__id" => organization.id,
        "organizations__author" => getCreator(organization),
        "organizations__name" => organization.name.capitalize,
        "organizations__active" => getStatus(organization.active),
        organization_actions: actions(organization)
      }
    end
  end

  def getCreator(organization)

    if organization.created_by
      usr = User.where(:id => organization.created_by)
      if usr.size == 1
        user = usr.first.email
      else
        user = "User Deleted ID was: #{organization.created_by}"
      end

    else
      user = "Error"
    end
  end

  def getStatus(active)
    if active
      status = "<span class='badge bg-color-greenLight'>ACTIVE</span"
    else
      status = "<span class='badge bg-color-red'>Pending Activation</span"
    end

    return status.html_safe
  end

  def actions(organization)
    render(:partial=>"admin/organization/actions.html.erb", locals: { organization: organization} , :formats => [:html])
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
    "name like :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end
