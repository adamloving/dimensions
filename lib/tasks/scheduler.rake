 # Resque tasks
 require 'resque/tasks'
 require 'resque_scheduler/tasks'

 namespace :resque do
   task :setup do
     Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
     ENV['QUEUE'] ||= '*'
     require 'resque'
     require 'resque_scheduler'
     require 'resque/scheduler'

     Resque.redis = 'localhost:6379'


   end
 end
