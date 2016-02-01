require 'singleton'

class RedisUtil
  include Singleton
  attr_reader :redis

  def initialize
    config = YAML::load_file("#{Rails.root}/config/redis.yml")[Rails.env]
    @redis = Redis.new host: config['host'], port: config['port'], thread_safe: true
  end

  def list_push_value(key, value)
    @redis.rpush key, value
  end

  def key_available?(key)
    @redis.type(key) == "none" ? false : true
  end
end
