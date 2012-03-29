class AddEtagAndLastModifiedToNewsFeeds < ActiveRecord::Migration
  def change
    add_column :news_feeds, :etag, :string

    add_column :news_feeds, :last_modified, :string

  end
end
