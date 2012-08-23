class FacebookCounter
  @queue = :feed_entry
  def self.perform
    FeedEntry.find_each do |entry|
      if entry.indexed?
        entry.update_facebook_stats
        entry.calculate_social_rank
        entry.re_index
      end
    end
  end
end
