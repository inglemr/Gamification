
# Version Data
  * Ruby: 2.2.3
  * Rails: 4.2.4
  * Database: postgresql

#Application Test Environments

* Staging Endpoint: [Staging](https://gsw-capstone.herokuapp.com/)

# Setup Locally
* Install [Postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
  * Install [PgAdmin](http://www.pgadmin.org/) (Optional) - Helpful with Database manipulation
* Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* Install [Rails](http://guides.railsgirls.com/install)
* Clone this repository locally using <tt>git clone git@github.com:inglemr/capstone.git</tt>
	* Navigate inside the capstone directory <tt>cd capstone</tt>
	* Install all the gems from the gemfile using <tt>bundle install</tt>
	* Run database migrations <tt>rake db:migrate</tt>
	* Run the local development server using <tt>rails server</tt>
	* Navigate to the app at <tt>localhost:3000</tt>
	* The app has been succesffuly installed

# Manage User Accounts

## Adding admin to a user

* User roles can be added through the rails console by navigating to the root directory of the app and using the command <tt>rails console</tt>
* Once the console has started run the follow command to find your user in the database <tt>user = User.find_by(:email => "<email>")</tt>
* To add a role to this user simply use <tt>user.add_role :Admin</tt>(Case is important) to add the admin role
* To finish just do <tt>user.save</tt> to save this record to the database
