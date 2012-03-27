require 'yaml'

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_yml = ERB.new(File.read("#{rails_root}/config/resque.yml")).result
resque_config = YAML.load(resque_yml)

Resque.redis = resque_config[rails_env]
