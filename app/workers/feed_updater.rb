class FeedUpdater
  @queue = :feeds

  def self.perform(news_feed_id)
    news_feed = NewsFeed.find(news_feed_id)
    news_feed.update_entries
  end
end
