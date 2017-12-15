REDIS_CONF = YAML.load_file("#{Rails.root}/config/settings/redis.yml")[Rails.env] # TODO: would be cool to have a service for loading yaml config files
TOKENS = Redis.new(host: REDIS_CONF['host'], port: REDIS_CONF['port'], db: REDIS_CONF['db'])
