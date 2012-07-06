class FacebookCounter
  @queue = :feed_entry
  def self.perform(entry_id)
    entry = FeedEntry.find_by_id(entry_id)
    entry.update_facebook_stats
  end
end
