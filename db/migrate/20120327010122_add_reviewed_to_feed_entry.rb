class AddReviewedToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :reviewed, :boolean, :default => false

  end
end
