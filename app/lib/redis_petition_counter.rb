# Wrapper around the number of signatures for a petition in Redis.
class RedisPetitionCounter
  attr_reader :petition_id

  def self.count(petition)
    new(petition).count
  end

  def initialize(petition)
    @petition_id = petition.id
  end

  def count
    redis.get(key).to_i
  end

  def delete
    redis.del(key)
  end

  def exists?
    redis.exists(key)
  end

  def increment
    redis.incr(key)
  end

  def update(value)
    redis.set(key, value)
  end

  # - Only update when already present in Redis
  # - When difference greater than 5, limit to 5
  def update_with_limit(value)
    return unless exists?

    value = count - 5 if count - value > 5
    redis.set(key, value)
  end

  private

  def redis
    Redis.current
  end

  def key
    "p#{petition_id}-count"
  end
end
