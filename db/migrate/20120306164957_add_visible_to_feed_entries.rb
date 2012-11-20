class AddVisibleToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :visible, :boolean, :default => true

  end
end
