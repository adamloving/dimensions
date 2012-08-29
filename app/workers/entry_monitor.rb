class EntryMonitor
  @queue = :entries

  def self.perform
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    NewsFeed.find_each do |feed|
      feed.reindex_feed index
    end
  end
end
