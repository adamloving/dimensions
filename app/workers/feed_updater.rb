class FeedUpdater
  @queue = :feeds

  def self.perform(news_feed_url)
    FeedEntry.update_from_feed_continuosly(news_feed_url)
  end
end
