## BASIC PERMISSIONS ##
 	 ## EVERYTHING
	 Permission.create!(:name => "Everything",:description => "Full Access", :subject_class => "all", :action => "manage")

	 ##Event Permissions
	 Permission.create!(:name => "Admin Events",:description => "Full Access to Events",:subject_class => "Admin::Event", :action => "manage")
	 Permission.create!(:name => "Admin Create Events",:description => "Create Events",:subject_class => "Admin::Event", :action => "create")
	 Permission.create!(:name => "Admin Update Events",:description => "Can only update events the user owns",:subject_class => "Admin::Event", :action => "update")

	 ##User
	 Permission.create!(:name => "Admin Users",:description => "Full Access to Users",:subject_class => "Admin::User", :action => "manage")

	 ##Roles
	 Permission.create!(:name => "Admin Roles",:description => "Full Access to Roles",:subject_class => "Admin::Role", :action => "manage")

	 ##Sidebar
	 Permission.create!(:name => "Admin Sidebar",:description => "View Admin Sidebar",:subject_class => "sidebar", :action => "manage")

	 ##Permissions
	 Permission.create!(:name => "Admin Permissions",:description => "Full Access to Permissions",:subject_class => "Admin::Permission", :action => "manage")

	 ##Customizer
	 Permission.create!(:name => "Admin Customize",:description => "Full Access to Customizer",:subject_class => "Admin::Customize", :action => "manage")


	 #Tags
	 Permission.create!(:name => "Admin Tags",:description => "Full Access to Tags",:subject_class => "Admin::Tag", :action => "manage")

	 #Resque
	 Permission.create!(:name => "Admin Resque",:description => "Full Access to Resque",:subject_class => "Admin::Resque", :action => "manage")

	 #API Permissions TODO(matt) DEPRECATED
	 Permission.create!(:name => "API Events",:description => "Full Access to Events API",:subject_class => "API::Event", :action => "manage")
	 Permission.create!(:name => "API Users",:description => "Full Access to Users API",:subject_class => "API::User", :action => "manage")
	 Permission.create!(:name => "API QRCodes",:description => "Full Access to QRCodes API",:subject_class => "API::Qrcode", :action => "manage")

	 #Organization
	 Permission.create!(:name => "Delete Organization Roles",:description => "Delete organization roles", :subject_class => "Organization", :action => "delete_role")
	 Permission.create!(:name => "Create Organization Roles",:description => "Create organization roles", :subject_class => "Organization", :action => "new_role")
	 Permission.create!(:name => "Edit Organization Roles",:description => "Edit organization roles", :subject_class => "Organization", :action => "edit_role")
	 Permission.create!(:name => "Add role to organization member",:description => "Add role to organization member", :subject_class => "Organization", :action => "member_role")
	 Permission.create!(:name => "View Organization Member Page",:description => "View Organization Member Page", :subject_class => "Organization", :action => "member_page")
	 Permission.create!(:name => "Access to create Request for organization",:description => "Access to new Request for organization form", :subject_class => "Organization", :action => "create_organization_request")
	 Permission.create!(:name => "Access to new Request for organization form",:description => "Access to new Request for organization form", :subject_class => "Organization", :action => "new_organization_request")
	 Permission.create!(:name => "View All Organizations",:description => "View Organizations", :subject_class => "Organization", :action => "read")
	 Permission.create!(:name => "Remove member from organization",:description => "Remove Member from organization", :subject_class => "Organization", :action => "remove_member")

	 #Request
	 Permission.create!(:name => "Decline organization invite",:description => "Decline organization invite", :subject_class => "Request", :action => "org_decline_invite")
	 Permission.create!(:name => "Accept organization invite",:description => "Accept organization invite", :subject_class => "Request", :action => "org_accept_invite")
	 Permission.create!(:name => "Request membership to organization",:description => "Request membership to organization", :subject_class => "Request", :action => "create_org_request")
	 Permission.create!(:name => "Invite member to organization",:description => "Invite member to organization", :subject_class => "Request", :action => "org_invite_member")

	 #Basic User Permissions
	 Permission.create!(:name => "View All Events Page",:description => "View All Events Page", :subject_class => "Event", :action => "all_events")
	 Permission.create!(:name => "View Events",:description => "View Events", :subject_class => "Event", :action => "read")
	 Permission.create!(:name => "View Dashboard",:description => "View Dashboard", :subject_class => "Dashboard", :action => "read")
	 Permission.create!(:name => "Show events on calander", :description => "Show events On Calander", :subject_class =>"Dashboard", :action => "cal_events")
	 Permission.create!(:name => "View my points",:description => "View my points", :subject_class => "Event", :action => "my_points")

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

   admin.save
   faculty.save
   student.save
