require "tweetstream"

task :start_streaming => :environment do
  TweetStream::Client.new.track("@dimensions") do |status|
    puts "#{status.id} : #{status.text}; Coincidencias: #{'1' if FeedEntry.where(:url => status.entities.urls[0]["expanded_url"]) }"
  end
end
