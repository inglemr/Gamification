# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



 # ADMIN Permissions
 Permission.create!(:name => "Everything",:description => "Full Access", :subject_class => "all", :action => "manage")
 Permission.create!(:name => "Admin Events",:description => "Full Access to Events",:subject_class => "Admin::Event", :action => "manage")
 Permission.create!(:name => "Admin Users",:description => "Full Access to Users",:subject_class => "Admin::User", :action => "manage")
 Permission.create!(:name => "Admin Roles",:description => "Full Access to Roles",:subject_class => "Admin::Role", :action => "manage") 
 Permission.create!(:name => "Admin Sidebar",:description => "View Admin Sidebar",:subject_class => "sidebar", :action => "manage")
 Permission.create!(:name => "Admin Permissions",:description => "Full Access to Permissions",:subject_class => "Admin::Permission", :action => "manage")

 #API Permissions
 Permission.create!(:name => "API Events",:description => "Full Access to Events API",:subject_class => "API::Event", :action => "manage")
 Permission.create!(:name => "API Users",:description => "Full Access to Users API",:subject_class => "API::User", :action => "manage")
 Permission.create!(:name => "API QRCodes",:description => "Full Access to QRCodes API",:subject_class => "API::Qrcode", :action => "manage")


 #Basic User Permissions
 Permission.create!(:name => "View Events",:description => "View Events", :subject_class => "Event", :action => "read")
 Permission.create!(:name => "View Dashboard",:description => "View Dashboard", :subject_class => "Dashboard", :action => "read")


 admin = Role.create!(:name => "Admin")
 student = Role.create!(:name => "Student") 
 student.permissions << Permission.find_by(:subject_class => 'Dashboard', :action => "read")
 student.permissions << Permission.find_by(:subject_class => 'Event', :action => "read")
 admin.permissions << Permission.find_by(:subject_class => 'all', :action => "manage")
