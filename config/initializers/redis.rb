
require 'redis_analytics'

# configure your redis_connection (mandatory) and redis_namespace (optional)
RedisAnalytics.configure do |configuration|
  configuration.redis_connection = Redis.new(host: 'localhost', port: '6379')
  configuration.redis_namespace = 'ra'
end

$redis = Redis.new(host: 'localhost', port: 6379)
