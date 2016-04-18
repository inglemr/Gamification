if Rails.env.production?
  $redis = Redis.new(url: Rails.application.secrets.redis_url)
else
  $redis = Redis.new(:host => '127.0.0.1', :port =>'6379')
end
Resque.redis = $redis
Resque::Scheduler.dynamic = true
