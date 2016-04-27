SSHKit.config.command_map[:rake] = "bundle exec rake"

set :application, 'gamification'
set :repo_url, 'git@github.com:inglemr/capstone.git'
set :deploy_to, '/var/www/gameification'
set :scm, :git
set :rvm_ruby_version, '2.3.0'

set :stages, ["production","staging"]
set :use_sudo, false
set :deploy_user, 'gswcm'


set :deploy_via, :remote_cache

#Passenger
#set :passenger_environment_variables, { :path => '/path-to-passenger/bin:$PATH' }
#set :passenger_restart_command, '/path-to-passenger/bin/passenger-config restart-app'

# Default value for :pty is false
# set :pty, true
#
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end
end



