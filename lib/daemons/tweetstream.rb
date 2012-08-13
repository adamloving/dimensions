#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "environment"))
require 'tweetstream'

logger = Logger.new("#{Rails.root}/log/tweetstream.log")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  # Replace this with your code
    TweetStream::Client.new.track("@dimensions") do |status|
      logger << status.text
      unless status.entities.urls.empty?
        logger << "#{status.id} : #{status.text}; Coincidencias: #{"\033[32m 1\033[0m" if FeedEntry.where(:url => status.entities.urls[0]["expanded_url"]) } \n"
        FeedEntry.add_tweet(status.entities.urls)
      end
      logger << "\n=======================================================================================================================\n"
    end
    logger.close
end
