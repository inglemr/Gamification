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

	 #API Permissions
	 Permission.create!(:name => "API Events",:description => "Full Access to Events API",:subject_class => "API::Event", :action => "manage")
	 Permission.create!(:name => "API Users",:description => "Full Access to Users API",:subject_class => "API::User", :action => "manage")
	 Permission.create!(:name => "API QRCodes",:description => "Full Access to QRCodes API",:subject_class => "API::Qrcode", :action => "manage")

	 #Event organizer Permissions

	 #Basic User Permissions
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
	 faculty.permissions << Permission.find_by(:subject_class => 'Event', :action => "read")

	 ##Admin Role
	 admin = Role.create!(:name => "Admin")
	 admin.permissions << Permission.find_by(:subject_class => 'all', :action => "manage")

	 ##Student Role
	 student = Role.create!(:name => "Student") 
	 student.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "read")
	 student.permissions << Permission.find_by(:subject_class => 'Event', :action => "read")
	 faculty.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "cal_events")
	 faculty.permissions << Permission.find_by(:subject_class => 'Event', :action => "my_points")
