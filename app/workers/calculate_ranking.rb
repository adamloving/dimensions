class CalculateRanking
  @queue = :feed_entry

  def self.perform(entry_id)
    entry = FeedEntry.find(entry_id)
    entry.update_facebook_stats
    entry.calculate_social_rank
    entry.re_index
  end
end
