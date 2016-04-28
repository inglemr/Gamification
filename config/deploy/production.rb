# #need to install cipher key



#Setup guide https://www.phusionpassenger.com/library/deploy/apache/automating_app_updates/ruby/
#https://www.phusionpassenger.com/library/deploy/nginx/automating_app_updates/ruby/

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.
#


role :app, %w{gswcm@gamification.gswcm.net}
role :web, %w{gswcm@gamification.gswcm.net}
role :db,  %w{gswcm@gamification.gswcm.net}

server 'gamification.gswcm.net',
  user: 'gswcm',
  roles: %w{web app db},
  ssh_options: {
    user: 'gswcm', # overrides user setting above
    forward_agent: true,
    port: 22,
   }

set :passenger_environment_variables, { :path => '/home/gswcm/.rvm/gems/ruby-2.3.0/gems/passenger-5.0.27/bin:$PATH' }
set :passenger_restart_command, '/home/gswcm/.rvm/gems/ruby-2.3.0/gems/passenger-5.0.27/bin/passenger-config restart-app'


set :deploy_to, '/var/www/gamification/production'
set :rails_env, "production"
set :branch, "master"
set :deployment_server, :passenger

set :rvm_type, :user
set :rvm_ruby_version, '2.3.0'
