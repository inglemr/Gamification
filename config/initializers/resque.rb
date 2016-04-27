$redis = Redis.new(:host => '127.0.0.1', :port =>'6379')
Resque.redis = $redis
Resque::Scheduler.dynamic = true
