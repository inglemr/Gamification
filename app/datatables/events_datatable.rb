class EventsDatatable
   delegate :params, :h, :day, :datetime ,:content_tag, :current_ability,:current_user, :render, :can?,:truncate, to: :@view

  def initialize(view)
    @view = view
    if(params[:recommended] != "1")
      if (params[:orgFilter] != "" && params[:locFilter] != "" && params[:tag] != "")
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").where(:location_id => params[:locFilter]).where(:organization_id => params[:orgFilter]).tagged_with(params[:tag], :any => true).upcoming_first.current_event#.past_events
      elsif params[:locFilter] != "" && params[:tag] != ""
         @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").where(:location_id => params[:locFilter]).tagged_with(params[:tag], :any => true).upcoming_first.current_event#.past_events
      elsif params[:orgFilter] != "" && params[:tag] != ""
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").where(:organization_id => params[:orgFilter]).tagged_with(params[:tag], :any => true).upcoming_first.current_event#.past_events
      elsif params[:locFilter] != ""
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").where(:location_id => params[:locFilter]).upcoming_first.current_event#.past_events
      elsif params[:orgFilter] != ""
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").where(:organization_id => params[:orgFilter]).upcoming_first.current_event#.past_events
      elsif params[:tag] != ""
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").tagged_with(params[:tag], :any => true).upcoming_first.current_event#.past_events
      else
        @events = Event.where(search_string, search: "%#{params[:sSearch] == nil ? params[:sSearch] : params[:sSearch].downcase}%").upcoming_first.current_event#.past_events
      end
    else
      # test = ActsAsTaggableOn::Tagging.where(:taggable_type => "Event").joins('INNER JOIN user_events ON user_events.attended_event_id = taggings.taggable_id').where('user_events.attendee_id = 1').map { |tagging| { 'id' => tagging.tag_id.to_s, 'name' => tagging.tag.name } }
      #  test = ActsAsTaggableOn::Tagging.where(:taggable_type => "Event").joins('LEFT OUTER JOIN user_events ON user_events.attended_event_id = taggings.taggable_id').where('user_events.attendee_id = 1')

      tags = ActsAsTaggableOn::Tagging.where(:taggable_type => "Event").joins('RIGHT OUTER JOIN user_events ON( user_events.attended_event_id = taggings.taggable_id AND user_events.attendee_id =' +  current_user.id.to_s + ')').map { |tagging| { 'id' => tagging.tag_id.to_s, 'name' => tagging.tag.name } }

      #Gets all tags of events that the user has attended
      temp = Hash.new
      tags.each do |tag|
        puts tag
        tem = temp[tag["name"]]
        if tem == nil
          tem = 0;
        end
        tem = tem.to_i + 1
        temp[tag["name"]] = tem
      end

      query_tags = Array.new
      top_tags = temp.sort_by {|k,v| v}.reverse[0..5]
      top_tags.each do |k,v|
        query_tags << k
      end

      @events = Event.tagged_with(query_tags, :any => true).current_event.upcoming_first
    end
    @events = @events.page(page).per_page(per_page)

  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @events.count,
      iTotalDisplayRecords: @events.total_entries,
      aaData: data
    }
  end

private

  def data
    @events.map do |event|
      {
        DT_RowId: event.id.to_s,
        DT_RowClass: '',
        DT_RowAttr: '',
        "events__id" => event.id,
        "events__event_name" => event.event_name,
        "events__description" => truncate(event.description, :length => 200, :separator => ' '),
        "events__location_id" => Location.find(event.location_id).building_name,
        "events__point_val" => event.point_val,
        events_eventTile: eventTile(event),
        "events__day_time" => event.day_time.to_formatted_s(:short)
      }
    end
  end

  def eventTile(event)
    render(:partial=>"events/event_tile.html.erb", locals: { event: event, style: "col-md-12 no-padding padding-bottom-10 padding-top-10"},:formats => [:html])
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
    "event_name LIKE :search OR description LIKE :search"
  end

  def sort_column
    [*0..params[:iColumns].to_i-1].map{|i| params["mDataProp_#{i}"].gsub("__", ".") if params["bSortable_#{i}"] != 'false' }[params[:iSortCol_0].to_i]
  end
end






