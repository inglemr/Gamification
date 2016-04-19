class Admin::EventsController < ApplicationController
	load_and_authorize_resource :context => :admin, :except => [:edit,:update,:new,:create,:destroy]
	before_filter :load_permissions
  before_filter :organization_perms

	def index
		respond_to do |format|
    		format.html
    		format.json { render json: Admin::EventsDatatable.new(view_context) }
  		end
	end

	def show
		@event = Event.find(params[:id])
	end

	def edit
    if ((can? :manage, :all) || @current_permissions["Admin::Event"].include?("create") || @current_permissions["Admin::Event"].include?("manage") ||  @org_perms.include?("everything")  || @org_perms.include?("manage-events"))
		  @event = Event.find(params[:id])
    else
      redirect_to :back, :flash => { :error => 'Unauthorized' }
    end
	end

	def update
    if ((can? :manage, :all) || @current_permissions["Admin::Event"].include?("create") || @current_permissions["Admin::Event"].include?("manage") ||  @org_perms.include?("everything")  || @org_perms.include?("manage-events"))
  		@event = Event.find(params[:id])
  		@event.image = params[:image]
  		if params[:event][:time] != ""
  			time = params[:time]
  			times = time.split.split("-")
  			params[:event][:day_time] = times[0]
  			params[:event][:day_time] = params[:event][:day_time][0] + " " + params[:event][:day_time][1] + " " + params[:event][:day_time][2]
  			params[:event][:end_time] = times[1]
  			params[:event][:end_time] = params[:event][:end_time][0] + " " + params[:event][:end_time][1] + " " + params[:event][:end_time][2]
  			params[:event].delete :time
      	start_time_no_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
      	end_time_no_zone = DateTime.strptime(params[:event][:end_time], "%m/%d/%Y %I:%M %p")
  			params[:event][:day_time] = Time.zone.parse(start_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
  			params[:event][:end_time] = Time.zone.parse(end_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
      end

      current_rooms = @event.rooms
      if params[:event][:rooms]
        params[:event][:rooms].delete("")
      end
      rooms = params[:event].delete(:rooms)
      params[:event].delete(:rooms)


      remove_rooms = Array.new
      current_rooms.each do |room|
        if !rooms.include?(room.id)
          @event.remove_room(room)
        end
      end
      if rooms.size > 0
        rooms.each do |room|
          tmp = Room.find(room)
          @event.add_room(tmp)
        end
      end

      current_hosts = @event.hosts
      hosts = params[:event][:id]
      params[:event].delete(:id)
      remove_host = Array.new
      current_hosts.each do |host|
        if !hosts.include?(host.id)
          @event.remove_host(host)
        end
      end
      if hosts.size > 0
        hosts.each do |host|
          if host.length > 0
            user = User.find(host)
            @event.add_host(user)
          end
        end
      end

      @event.tag_list = params[:event][:tag_list]

  		if @event.update_attributes(event_params)

    		redirect_to admin_events_path, :flash => { :success => 'Event was successfully updated.' }
  		else
    		render :edit , :flash => { :error => 'Event was unsuccesfully updated.' }
  		end
    else
      redirect_to :back, :flash => { :error => 'Unauthorized.' }
    end
	end

	def new
    if ((can? :manage, :all) || @current_permissions["Admin::Event"].include?("create") || @current_permissions["Admin::Event"].include?("manage") ||  @org_perms.include?("everything")  || @org_perms.include?("manage-events"))
		  @event = Event.new
		  @locations = Location.all.pluck(:building_name)
    end
	end

	def create
    if ((can? :manage, :all) || @current_permissions["Admin::Event"].include?("create") || @current_permissions["Admin::Event"].include?("manage") ||  @org_perms.include?("everything")  || @org_perms.include?("manage-events"))
  		#Recurring Events
  		recureInterval = params[:event_recure_intervals]
  		recureDays = params[:event_days]
  		recureEvent = params[:event_type]
  		recureStop = []
  		excludeEvent = "";
  		if( recureEvent == "recure")
  			excludeEvent = params[:exclude].split(",")
  			recureStop = params[:recudeEndDate]
  			recureStart = params[:recudeStartDate]
  			start = recureStart + " " + params[:event][:day_time] + " EST"
  			endT = recureStart + " " + params[:event][:end_time] + " EST"
  			startTime = DateTime.parse(start)
  			endTime = DateTime.parse(endT)
  			params[:event][:day_time] = startTime
  			params[:event][:end_time] = endTime
  		else
  			if params[:event][:time] != ""
  				time = params[:time]
  				times = time.split.split("-")
  				params[:event][:day_time] = times[0]
  				params[:event][:day_time] = params[:event][:day_time][0] + " " + params[:event][:day_time][1] + " " + params[:event][:day_time][2]
  				params[:event][:end_time] = times[1]
  				params[:event][:end_time] = params[:event][:end_time][0] + " " + params[:event][:end_time][1] + " " + params[:event][:end_time][2]
  				params[:event].delete :time
  	    	start_time_no_zone = DateTime.strptime(params[:event][:day_time], "%m/%d/%Y %I:%M %p")
  	    	end_time_no_zone = DateTime.strptime(params[:event][:end_time], "%m/%d/%Y %I:%M %p")
  				params[:event][:day_time] = Time.zone.parse(start_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
  				params[:event][:end_time] = Time.zone.parse(end_time_no_zone.strftime('%Y-%m-%d %H:%M:%S'))
      	end
  		end

  		params[:event].delete(:recudeEndDate)
  		params[:event].delete(:exclude)
  		params[:event].delete(:recurring_id)

  		# Room Numbers
  		if params[:event][:rooms]
  			params[:event][:rooms].delete("")
  		end
      rooms = params[:event].delete(:rooms)
  		#Time parsing

      params[:event][:created_by] = current_user.id
      params[:event][:updated_by] = current_user.id

  		@event = Event.new(event_params)
      if rooms.size > 0
        rooms.each do |room|
          @event.add_room(room)
        end
      end

  		@event.image = params[:image]

      #Designated Host
      hosts = params[:event][:id].delete("")
      if hosts.size > 0
        hosts.each do |host|
          user = User.find(host)
          @event.add_host(user)
        end
      end

      @event.tag_list = params[:event][:tag_list]

  		if @event.save
  			if(recureEvent == "recure")
  				@event.recurring_id = @event.id
  				@event.createRecurrences(recureStop, excludeEvent, recureDays, recureInterval,recureStart)
  				@event.save
  			end
  			if can? :show, Event, :context => :admin
    			redirect_to admin_event_path(@event), :flash => { :success => 'Event created successfully.' }
    		else
    			redirect_to root_path , :flash => { 'success' => 'Event created successfully.' }
    		end
    	else
    		render 'new'
    	end
    else
      redirect_to :back , :flash => { :error => 'Unauthorized'}
    end
	end

def destroy
  if ((can? :manage, :all) || @current_permissions["Admin::Event"].include?("create") || @current_permissions["Admin::Event"].include?("manage") ||  @org_perms.include?("everything")  || @org_perms.include?("manage-events"))
    @event = Event.find(params[:id])
    if (@event.attendees.size == 0)
       flash[:success] = "Event deleted successfully"
      @event.destroy
    else
      flash[:danger] = "Event can not be deleted with attendees"
    end
    redirect_to :back
  else
    redirect_to :back, :flash => { :error => "Unauthorized"}
  end
end

private

  def organization_perms
    org_perms = Array.new
    params[:org_id] ||= params[:organization_id]
    if params[:org_id]
      @organization = Organization.find(params[:org_id])
      if current_user.organizations.include? @organization
        current_user.org_roles.where(:org_id => @organization.id).each do |role|
          role.permissions.each do |perm|
            org_perms << perm.to_s.gsub('"', '')
          end
        end
      end
    end
    @org_perms = org_perms.uniq
  end


  def event_params
    params.require(:event).permit(:rooms,:location_id,:end_time,:event_name, :organization_id, :day_time, :point_val, :description, :created_by, :updated_by, :image, :tag_list)
  end

	def self.permission
	  return "Admin::Events"
	end


end
