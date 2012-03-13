class AddFailedToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :failed, :boolean, :default => false

  end
end
