class AddFetchErrorsToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :fetch_errors, :string

  end
end
