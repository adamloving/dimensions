class FacebookCounter
  @queue = :feed_entry
  def self.perform
    FeedEntry.to_recalculate.each do |entry|
      entry.bg_calculate_social_rank
    end
  end
end
