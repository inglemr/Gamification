## BASIC PERMISSIONS ##
 	 ## EVERYTHING
	 Permission.create!(:name => "Everything",:description => "Full Access", :subject_class => "all", :action => "manage", :scope => "Master Admin")

	 ##Event Permissions
	 Permission.create!(:name => "Admin Events",:description => "Full Access to Events",:subject_class => "Admin::Event", :action => "manage", :scope => "Admin")
	 Permission.create!(:name => "Admin Create Events",:description => "Create Events",:subject_class => "Admin::Event", :action => "create", :scope => "Admin")
	 Permission.create!(:name => "Admin Update Events",:description => "Can only update events the user owns",:subject_class => "Admin::Event", :action => "update", :scope => "Admin")

	 ##User
	 Permission.create!(:name => "Admin Users",:description => "Full Access to Users",:subject_class => "Admin::User", :action => "manage", :scope => "Admin")

	 ##Roles
	 Permission.create!(:name => "Admin Roles",:description => "Full Access to Roles",:subject_class => "Admin::Role", :action => "manage", :scope => "Admin")

	 ##Sidebar
	 Permission.create!(:name => "Admin Sidebar",:description => "View Admin Sidebar",:subject_class => "sidebar", :action => "manage", :scope => "Admin")

	 ##Permissions
	 Permission.create!(:name => "Admin Permissions",:description => "Full Access to Permissions",:subject_class => "Admin::Permission", :action => "manage", :scope => "Admin")

	 ##Customizer
	 Permission.create!(:name => "Admin Customize",:description => "Full Access to Customizer",:subject_class => "Admin::Customize", :action => "manage", :scope => "Admin")


	 #Tags
	 Permission.create!(:name => "Admin Tags",:description => "Full Access to Tags",:subject_class => "Admin::Tag", :action => "manage", :scope => "Admin")

	 #Resque
	 Permission.create!(:name => "Admin Resque",:description => "Full Access to Resque",:subject_class => "Admin::Resque", :action => "manage", :scope => "Admin")

	 #API Permissions TODO(matt) DEPRECATED
	 Permission.create!(:name => "API Events",:description => "Full Access to Events API",:subject_class => "API::Event", :action => "manage", :scope => "Admin")
	 Permission.create!(:name => "API Users",:description => "Full Access to Users API",:subject_class => "API::User", :action => "manage", :scope => "Admin")
	 Permission.create!(:name => "API QRCodes",:description => "Full Access to QRCodes API",:subject_class => "API::Qrcode", :action => "manage", :scope => "Admin")

	 #Organization

   Permission.create!(:name => "Create Organization Articles",:description => "Create Organization Articles", :subject_class => "Organization", :action => "create_article", :scope => "Organization")
	 Permission.create!(:name => "Delete Organization Roles",:description => "Delete organization roles", :subject_class => "Organization", :action => "delete_role", :scope => "Organization")
	 Permission.create!(:name => "Create Organization Roles",:description => "Create organization roles", :subject_class => "Organization", :action => "new_role", :scope => "Organization")
	 Permission.create!(:name => "Edit Organization Roles",:description => "Edit organization roles", :subject_class => "Organization", :action => "edit_role", :scope => "Organization")
	 Permission.create!(:name => "Add role to organization member",:description => "Add role to organization member", :subject_class => "Organization", :action => "member_role", :scope => "Organization")
	 Permission.create!(:name => "View Organization Member Page",:description => "View Organization Member Page", :subject_class => "Organization", :action => "member_page", :scope => "Organization")
	 Permission.create!(:name => "Access to create Request for organization",:description => "Access to new Request for organization form", :subject_class => "Organization", :action => "create_organization_request", :scope => "Organization")
	 Permission.create!(:name => "Access to new Request for organization form",:description => "Access to new Request for organization form", :subject_class => "Organization", :action => "new_organization_request", :scope => "Organization")
	 Permission.create!(:name => "View All Organizations",:description => "View Organizations", :subject_class => "Organization", :action => "read", :scope => "Organization")
	 Permission.create!(:name => "Remove member from organization",:description => "Remove Member from organization", :subject_class => "Organization", :action => "remove_member", :scope => "Organization")

	 #Request
   Permission.create!(:name => "Decline Member Request",:description => "Decline member request ", :subject_class => "Request", :action => "org_decline_member", :scope => "Request")#
   Permission.create!(:name => "Accept Member Request",:description => "Accept member request ", :subject_class => "Request", :action => "org_accept_member", :scope => "Request")#
	 Permission.create!(:name => "Decline organization invite",:description => "Decline organization invite", :subject_class => "Request", :action => "org_decline_invite", :scope => "Request")
	 Permission.create!(:name => "Accept organization invite",:description => "Accept organization invite", :subject_class => "Request", :action => "org_accept_invite", :scope => "Request")
	 Permission.create!(:name => "Request membership to organization",:description => "Request membership to organization", :subject_class => "Request", :action => "create_org_request", :scope => "Request")
	 Permission.create!(:name => "Invite member to organization",:description => "Invite member to organization", :subject_class => "Request", :action => "org_invite_member", :scope => "Request")

	 #Basic User Permissions
	 Permission.create!(:name => "View All Events Page",:description => "View All Events Page", :subject_class => "Event", :action => "all_events", :scope => "Event")
	 Permission.create!(:name => "View Events",:description => "View Events", :subject_class => "Event", :action => "read", :scope => "Event")
	 Permission.create!(:name => "View Dashboard",:description => "View Dashboard", :subject_class => "Dashboard", :action => "read", :scope => "Dashboard")
	 Permission.create!(:name => "Show events on calander", :description => "Show events On Calander", :subject_class =>"Dashboard", :action => "cal_events", :scope => "Dashboard")
	 Permission.create!(:name => "View my points",:description => "View my points", :subject_class => "Event", :action => "my_points", :scope => "Event")

## BASIC ROLES ##
	 ##Faculty Role
	 faculty = Role.create!(:name => "Faculty")
	 faculty.permissions << Permission.find_by(:subject_class => 'Admin::Event', :action => "create")
	 faculty.permissions << Permission.find_by(:subject_class => 'Admin::Event', :action => "update")
	 faculty.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "read")
	 faculty.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "cal_events")
	 faculty.permissions << Permission.find_by(:subject_class => 'Event', :action => "my_points")
	 faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "read")
	 faculty.permissions << Permission.find_by(:subject_class => 'Event', :action => "all_events")

	 faculty.permissions << Permission.find_by(:subject_class => 'Event', :action => "read")
	 faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "delete_role")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "new_role")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "edit_role")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "create_article")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "member_role")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "member_page")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "create_organization_request")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "new_organization_request")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "read")
   faculty.permissions << Permission.find_by(:subject_class => 'Organization', :action => "remove_member")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_decline_invite")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_accept_invite")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "create_org_request")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_invite_member")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_accept_member")
   faculty.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_decline_member")

	 ##Admin Role
	 admin = Role.create!(:name => "Admin")
	 admin.permissions << Permission.find_by(:subject_class => 'all', :action => "manage")

	 ##Student Role
	 student = Role.create!(:name => "Student")
	 student.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "cal_events")
	 student.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "read")
	 student.permissions << Permission.find_by(:subject_class => 'Event', :action => "read")
	 student.permissions << Permission.find_by(:subject_class => 'Event', :action => "all_events")
	 student.permissions << Permission.find_by(:subject_class => 'Event', :action => "my_points")

   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "create_article")
	 student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "delete_role")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "new_role")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "edit_role")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "member_role")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "member_page")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "create_organization_request")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "new_organization_request")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "read")
   student.permissions << Permission.find_by(:subject_class => 'Organization', :action => "remove_member")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_decline_invite")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_accept_invite")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "create_org_request")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_invite_member")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_accept_member")
   student.permissions << Permission.find_by(:subject_class => 'Request', :action => "org_decline_member")

##SCHOOL LOCATIONS##
	location_list = [
		"Wheatley Administration Building",
		"Crawford Wheatley Hall",
		"Newman Alumni Center",
		"Former President's Home",
		"Collum Hall",
		"Storm Dome/Athletic Center",
		"Florrie Chappell Gymnasium",
		"Science Building",
		"Joseph C. Roney Building",
		"Jackson Hall",
		"Academic Center for Excellence",
		"English Building",
		"Business/History & Political Science Building",
		"Maintenence/Warehouse",
		"James Earl Carter Library",
		"Marshall Student Center",
		"Mary Lou Jordan Hall",
		"Sanford Hall",
		"Morgan Hall",
		"Herschel Smith: Public Safety",
		"Beth King Duncan Hall",
		"Lake House",
		"Fine Arts Building",
		"Education Center",
		"Deriso Swimming Pool",
		"Student Success Center",
		"Southwestern Oaks I",
		"Southwestern Oaks II",
		"Southwestern Pines",
		"Magnolia I",
		"Magnolia II",
		"Carter 1 (Nursing/Health Center)",
		"Carter 2 (Psy/Soc/RCI)",
		"Off Campus"
	]

	location_list.each do |name|
		Location.create(building_name: name)
	end

##TAGS##
	tag_list = [
		"Sports", "Baseball", "Men's Basketball", "Women's Basketball", "Cross Country", "Golf", "Men's Soccer",
		"Women's Soccer", "Softball", "Men's Tennis", "Women's Tennis", "CAB", "Movies", "W2W", "Health", "Convocation",
		"ELI Film Series", "Music", "Chamber Concert", "Worship", "Board Games", "Intramural", "Taste Of The World", "Food",
		"Red Cross", "Blood Drive", "Clothes", "Fashion", "Lecture", "Workshop", "Fair", "Career Fair", "Majors Fair",
		"Band", "Jazz", "Concert", "POWMIA", "Grand Opening", "Lunch", "Dinner", "Breakfast", "Fraternity", "Sorority",
		"Club", "Party", "Seminar", "Class", "Homecoming", "Panorama" ]

	tag_list.each do |name|
		Tag.create(name: name)
	end














