class FacebookCounter
  @queue = :feed_entry
  def self.perform
    FeedEntry.find_each do |entry|
      entry.bg_calculate_social_rank if entry.indexed?
    end
  end
end
