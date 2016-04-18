require 'resque/tasks'
require 'resque/scheduler'
require 'resque/scheduler/tasks'
require 'resque/pool/tasks'
require 'resque/pool'

namespace :jobs do
  namespace :redis do
    desc "Make sure redis server is running"
    task :start  do
      res = `ps aux | grep redis-server`
      redis_conf = Rails.root.join("config/redis", "reddis.conf")
      redis_conf = redis_conf.to_s.gsub(' ', '\ ')

      if res.include?("redis-server #{Rails.application.secrets.redis_url}")
        puts "Redis Server Already Running"
      else
        puts "Starting Redis Server"
        cmd = "redis-server #{redis_conf}"
        system(cmd)
      end
    end
  end

  namespace :pool do
    task :setup  do
      require 'resque/pool/tasks'
      require 'resque/pool'

      ActiveRecord::Base.connection.disconnect!
     # Resque::Pool.config_files= File.absolute_path("config/resque-pool.yml")
      Resque::Pool.after_prefork do |job|
        ActiveRecord::Base.establish_connection
        Resque.redis.client.reconnect
      end
    end

    task :start do
      pidfile = Rails.root + "tmp/pids/resque-pool.pid"
      if File.exists?(pidfile)
        puts "Resque Pool Already Running"
      else
        puts "Starting Resque Pool"
        cmd = "RAILS_ENV=#{Rails.env} RESQUE_WORKER=false resque-pool --daemon --environment #{Rails.env}"
        system(cmd)
      end
    end

    task :stop do
      pidfile = Rails.root + "tmp/pids/resque-pool.pid"
      if !File.exists?(pidfile)
        puts "Resque Pool not running"
      else
        pid = File.read(pidfile).to_i
        cmd = "kill -INT #{pid}"
        puts "Stopping Resque Pool"
        system(cmd)
        FileUtils.rm_f(pidfile)
      end
    end
  end
  namespace :scheduler do
    desc "Start resque-scheduler"
    task :start do
      res = "ps aux | grep resque-scheduler"
      if res.include? "[#{Rails.env}]"
        puts "Resque Scheduler Already Running"
      else
        puts "Starting Resque Scheduler"
        env_vars = {
          "BACKGROUND" => "1",
          "PIDFILE" => (Rails.root + "tmp/pids/resque_scheduler.pid").to_s,
          "VERBOSE" => "1",
          "DYNAMIC_SCHEDULE" => 'true'
        }
        ops = {:pgroup => true, :err => [(Rails.root + "log/resque_scheduler_error.log").to_s, "a"],
                                :out => [(Rails.root + "log/resque_scheduler.log").to_s, "a"]}
        pid = spawn(env_vars, "rake resque:scheduler  QUEUE=*", ops)
        Process.detach(pid)
      end
    end

    desc "Stop resque-scheduler"
    task :stop  do
      pidfile = Rails.root + "tmp/pids/resque_scheduler.pid"
      if !File.exists?(pidfile)
        puts "Resque Scheduler not running"
      else
        pid = File.read(pidfile).to_i
        syscmd = "kill -s QUIT #{pid}"
        puts "Stopping Resque Scheduler"
        system(syscmd)
        FileUtils.rm_f(pidfile)
      end
    end
  end

  task :wait do
    puts "Waiting........"
    sleep(10)
  end

  #task :setup => :anemic_environment do
  task :setup  => :environment do
    Resque.redis =  Rails.application.secrets.redis_url
   # Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  end
  task :setup_schedule => :setup do
    require 'resque/scheduler/tasks'
    Resque.schedule = YAML.load_file(Rails.root.join('config/resque_schedule.yml'))[Rails.env]
    Resque::Scheduler.dynamic = true
  end
  task :scheduler_setup => :setup_schedule


  desc "Start Resque Up"
  task :stop => ['jobs:pool:stop', 'jobs:scheduler:stop', 'jobs:wait']
  task :start => ['jobs:clear', 'jobs:pool:start', 'jobs:scheduler:start']
  task :work => ['jobs:stop', 'jobs:start']



  desc "Clear pending tasks"
  task :clear => :environment do
    puts "Clearing queues..."
    Resque.queues.each do |queue_name|
      Resque.remove_queue(queue_name)
    end

    puts "Clearing delayed..."
    Resque.redis.keys("delayed:*").each do |key|
      Resque.redis.del "#{key}"
    end
    Resque.redis.del "delayed_queue_schedule"

    puts "Clearing stats..."
    Resque.redis.set "stat:failed", 0
    Resque.redis.set "stat:processed", 0

    puts "Clearing concurrent..."
    Resque.redis.keys("concurrent*").each do |key|
      Resque.redis.del "#{key}"
    end

    puts "Clearing history..."
    Resque.redis.keys("resque_history*").each do |key|
      Resque.redis.del "#{key}"
    end
  end
end


task :anemic_environment do
  raise "Please set your RESQUE_WORKER variable to true" unless ENV['RESQUE_WORKER'] == "true"
  $:.unshift File.join(ROOT_PATH, "app/models")
  $:.unshift File.join(ROOT_PATH, "app/workers")
  $:.unshift File.join(ROOT_PATH, "lib")
  db = YAML.load_file File.join(ROOT_PATH, "config/database.yml")
  puts db[RAILS_ENV]
  ActiveRecord::Base.establish_connection db[RAILS_ENV]
  Dir[
      File.join(ROOT_PATH, "app/workers/*.rb"),
      File.join(ROOT_PATH, "app/models/*.rb"),
      File.join(ROOT_PATH, "lib/*.rb")
  ].each do |f|
    name = f.split("/").last.gsub(/\.rb$/, "")
    autoload name.camelize, name
  end

end
