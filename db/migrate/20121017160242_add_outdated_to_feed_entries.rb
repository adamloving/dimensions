class AddOutdatedToFeedEntries < ActiveRecord::Migration
  def up
    add_column :feed_entries, :outdated, :boolean, default: false
  end

  def down
    remove_column :feed_entries, :outdated
  end
end
