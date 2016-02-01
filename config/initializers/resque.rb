require 'resque'
# require 'resque_scheduler'
# require 'resque_scheduler/server'
# require 'resque-loner'
require 'yaml'

Dir["#{Rails.root}/app/jobs/**/*.rb"].each {|file| require file}
# Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.redis = RedisUtil.instance.redis
