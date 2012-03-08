class AddFailedToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :failed, :boolean

  end
end
