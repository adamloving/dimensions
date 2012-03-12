class DeleteFieldsToFeedEntries < ActiveRecord::Migration
  def change
    remove_column :feed_entries, :shortname
    remove_column :feed_entries, :country
    remove_column :feed_entries, :latitude
    remove_column :feed_entries, :longitude
  end
end
