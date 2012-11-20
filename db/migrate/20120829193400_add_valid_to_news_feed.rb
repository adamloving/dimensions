class AddValidToNewsFeed < ActiveRecord::Migration
  def change
    add_column :news_feeds, :valid_feed, :boolean, :default => true
  end
end
