class CalculateRanking
  @queue = :rankings

  def self.perform(entry_id)
    entry = FeedEntry.find_by_id(entry_id)
    entry.ranking_calculate
  end
end
