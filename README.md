
# Version Data
  * Ruby: 2.3.0
  * Rails: 4.2.4
  * Database: postgresql

#Application Test Environments

* Staging Endpoint: [Staging](https://gsw-capstone.herokuapp.com/)

# Setup Locally
* Install [Postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
  * Install [PgAdmin](http://www.pgadmin.org/) (Optional) - Helpful with Database manipulation
* Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* Install [Rails](http://guides.railsgirls.com/install)
* Install [ImageMagick](http://www.imagemagick.org/script/binary-releases.php) for images
* Clone this repository locally using <tt>git clone git@github.com:inglemr/Gamification.git</tt>
	* Navigate inside the capstone directory <tt>cd capstone</tt>
	* Install all the gems from the gemfile using <tt>bundle install</tt>
	* Run database migrations <tt>rake db:migrate</tt>
	* Run database seed <tt>rake db:seed</tt> (This will add all permissions into the database and the admin role)
	* Run the local development server using <tt>rails server</tt>
	* Navigate to the app at <tt>localhost:3000</tt>
	* The app has been succesffuly installed

# Manage User Accounts

## Adding admin to a user

* User roles can be added through the rails console by navigating to the root directory of the app and using the command <tt>rails console</tt>
* Once the console has started run the follow command to find your user in the database <tt>user = User.find_by(:email => "your_email")</tt>
* To add a role to this user simply use <tt>user.add_role :Admin</tt>(Case is important) to add the admin role

# App Documentation

### Documentation was generated using [YARD](https://gist.github.com/chetan/1827484)
  
* Generate Documentation and Viewing it
 	* Documentation can be generated in a development environment by running <tt>yard doc </tt> this only needs to be done as code changes are made
	* The documentation can then be viewed by running <tt>yard server</tt> which runs a local server that host the HTML documenation and can be viewed by going to <tt>localhost:8808</tt>(Default port)
	* This server can run alongside the application server since they utilize different ports

# Deploying application to production environment
## Deployment Information
    Gamification has been setup to use Passenger/Nginx as its application server
    
## Deployment Steps
* Deployment has been simplified and simply requires that your machine has ssh access into the production server
* Deployments can be made by simply typing <tt>cap production deploy</tt> this command should be run on your local development machine. NOTE: The deployment pulls data from github so ensure that the repo is updated with the commits you are intending to deploy
* All deployment task are automated by using capistrano


# Development Roadmap

## Future Development Ideas
* Utilize a backend job/worker scheduler [Resque/Redis](https://github.com/resque/resque) to handle long running jobs that would otherwise slow down the web facing interface. For example the worker would preform the operation and the web interface should be informed on its complition. A good example of an operation that could use this functionality is when a user creates recurring events or when a user updates there records from RAIN
* Add hard coded site settings to the database that stores settings in key value pairs ( each setting being a diffrent record) this would allow an admin to  change settings in the web interface such as the range of points available or the colors of the website. This would make the application more dynamic and allow for administration to make large scale changes without needing to change the application source code

