class AddTweetsCountToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :tweet_count, :integer, :default => 0
  end
end
