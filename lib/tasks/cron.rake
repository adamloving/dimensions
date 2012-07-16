desc "This task is called by the Heroku cron add-on"

task :cron => :environment do
  if Time.now.hour % 3 == 0 # run every six hours
    NewsFeed.find_each do |feed|
      puts "Updating feed #{feed.name}, #{feed.url}"
      Resque.enqueue(FeedUpdater, feed.id)
      puts "done."
    end
    Resque.enqueue(FacebookCounter)
  end
end
