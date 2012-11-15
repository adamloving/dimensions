class AddFacebookCountToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :facebook_count, :integer, :default => 0
  end
end
