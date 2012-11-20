class AddStateToFeedEntries < ActiveRecord::Migration
  def up
    add_column :feed_entries, :state, :string
  end
  def down
    remove_column :feed_entries, :state
  end
end
