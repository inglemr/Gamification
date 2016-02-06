class Admin::LogsDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @logs = Log.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
    @logs = @logs.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @logs.count,
      iTotalDisplayRecords: @logs.total_entries,
      aaData: data
    }
  end

private

  def data 
    @logs.map do |log|
      {
        'DT_RowId' => log.id.to_s,
        "logs__id" => log.id,
        "logs__user_id" => log.user_id,
        "logs__path" => log.path,
        "logs__params" => log.params
      }
    end
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
    "path LIKE :search or params LIKE :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end






