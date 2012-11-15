require 'yaml'

Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_scheduler.yml')) # load the schedule
