class AddNewsFeedIdToEntities < ActiveRecord::Migration
  def up
    add_column :entities, :news_feed_id, :integer
  end

  def down
    remove_column :entities, :news_feed_id
  end
end
