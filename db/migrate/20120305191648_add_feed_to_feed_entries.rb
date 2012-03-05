class AddFeedToFeedEntries < ActiveRecord::Migration
  def change
    change_table :feed_entries do|t|
      t.references :news_feed
    end
  end
end
