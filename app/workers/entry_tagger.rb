class EntryTagger
  @queue = :entries

  def self.perform(entry_id)
    entry = FeedEntry.find(entry_id)
    FeedEntry.tag(entry)
  end
end
