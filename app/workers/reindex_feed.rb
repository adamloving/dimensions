class ReindexFeed
  @queue = :reindex_entries

  def self.perform(feed_id)
    NewsFeed.find(feed_id).reindex_feed
  end
end
