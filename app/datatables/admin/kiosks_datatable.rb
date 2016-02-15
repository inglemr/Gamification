class Admin::KiosksDatatable
   delegate :params, :h,  :content_tag, :current_ability, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    @kiosks = Kiosk.order("#{sort_column} #{sort_direction}").where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%")
    @kiosks = @kiosks.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @kiosks.count,
      iTotalDisplayRecords: @kiosks.total_entries,
      aaData: data
    }
  end

private

  def data

    @kiosks.map do |kiosk|
      {
        'DT_RowId' => kiosk.id.to_s,
        "kiosks__id" => kiosk.id,
        "kiosks__kiosk_name" => kiosk.kiosk_name,
        kiosk_actions: actions(kiosk)
      }
    end
  end

  def actions(kiosk)
    render(:partial=>"admin/kiosks/actions.html.erb", locals: { kiosk: kiosk} , :formats => [:html]) 
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
    "kiosk_name like :search" 
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end


  