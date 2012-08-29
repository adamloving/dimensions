class EntryMonitor
  @queue = :entries

  def self.perform
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    FeedEntry.find_each do |entry|
      if entry.tagged? and !entry.indexed?
        entry.index_in_searchify index
      end
    end
  end
end
