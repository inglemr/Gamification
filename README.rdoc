== README

Staging Endpoint: [Staging](https://gsw-capstone.herokuapp.com/)

Database: postgresql

#Setup Locally
	* Install [Postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
	  *Install [PgAdmin](http://www.pgadmin.org/) (Optional) - Helpful with Database manipulation
	* Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
	* Install [Rails](http://guides.railsgirls.com/install)
	* Clone this repository locally using <tt>git clone git@github.com:inglemr/capstone.git</tt>
		*Navigate inside the capstone directory and run the following commands <tt>cd capstone</tt>
		*Install all the gems from the gemfile using <tt>bundle install</tt>
		*Run database migrations <tt>rake db:migrate</tt>
		*Run the local development server using <tt>rails server</tt>
		*Navigate to the app at <tt>localhost:3000</tt>
		*The app has been succesffuly installed
#Manage User Accounts

	##List Of Roles
		*:admin -> Can access all documents/controllers/views/models
	##Adding user roles
		*User roles can be added through the rails console by navigating to the root directory of the app and using the command <tt>rails console</tt>
		*Once the console has started run the follow command to find your user in the database <tt>user = User.find_by(:email => "<email>")</tt>
		*To add a role to this user simply use <tt>user.add_role :admin</tt> to add the admin role
		*To finish just do <tt>user.save</tt> to save this record to the database
