class AddIndexedToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :indexed, :boolean, :default => false

  end
end
