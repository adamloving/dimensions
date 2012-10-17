class AddOutdatedToFeedEntries < ActiveRecord::Migration
  def up
    add_column :feed_entries, :outdated, :boolean
  end

  def down
    remove_column :feed_entries, :outdated
  end
end
