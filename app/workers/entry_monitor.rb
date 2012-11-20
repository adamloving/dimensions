class EntryMonitor
  @queue = :reindex_entries

  def self.perform
    NewsFeed.find_each do |feed|
      feed.bg_reindex_feed
    end
  end
end
