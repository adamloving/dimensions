class ReindexFeed
  @queue = :reindex_entries

  def self.perform(feed_id, index)
    feed = NewsFeed.find(feed_id)
    feed.reindex_feed index
  end
end
