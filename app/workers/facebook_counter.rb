class FacebookCounter
  @queue = :feed_entry
  def self.perform
    FeedEntry.find_each do |entry|
      entry.update_facebook_stats
      entry.calculate_social_rank
    end
  end
end
