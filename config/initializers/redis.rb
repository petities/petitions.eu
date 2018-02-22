require 'redis_analytics'

# configure your redis_connection (mandatory) and redis_namespace (optional)
RedisAnalytics.configure do |configuration|
  configuration.redis_connection = Redis.new
  configuration.redis_namespace = 'ra'
end
