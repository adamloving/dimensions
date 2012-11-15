class CleanIndexes
  @queue = :clean_index
  
  def self.perform
    FeedEntry.remove_this_entries
  end

end
