require "tweetstream"

namespace :tweetstream do
  desc "Starts the stream of tweets"
  task :start_streaming => :environment do
    logger = Logger.new("#{Rails.root}/log/tweet_stream.log")
    TweetStream::Client.new.track("@dimensions") do |status|
       logger << "#{status.id} : #{status.text}; Coincidencias: #{"\033[32m 1\033[0m" if FeedEntry.where(:url => status.entities.urls[0]["expanded_url"]) } \n"
       FeedEntry.add_tweet(status.entities.urls)
       logger << "=======================================================================================================================\n"
    end
    logger.close
  end
end
