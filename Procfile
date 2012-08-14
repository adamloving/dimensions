web:    bundle exec thin start -p 5000 -s 3 -e staging
worker: bundle exec rake resque:work QUEUE=* RAILS_ENV=staging --trace
clock:  bundle exec rake resque:scheduler RAILS_ENV=staging --trace
