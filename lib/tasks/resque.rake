require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  ENV['QUEUE'] ||= '*'
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
end

task "resque:scheduler_setup" => :environment

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => ["resque:work", "resque:scheduler"]

