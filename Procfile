web:    bundle exec thin -p 5000 -s 3 -e staging start 
worker: bundle exec rake resque:work QUEUE=* RAILS_ENV=staging
clock:  bundle exec rake resque:scheduler RAILS_ENV=staging
