class AddFacebookCountFieldsToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :facebook_likes, :integer, :default => 0
    add_column :feed_entries, :facebook_shares, :integer, :default => 0
    add_column :feed_entries, :facebook_comments, :integer, :default => 0

    remove_column :feed_entries, :facebook_count
  end
end
