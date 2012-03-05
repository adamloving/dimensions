class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.string :name
      t.string :url

      t.timestamps
    end

    add_index :news_feeds, :name, unique: true
    add_index :news_feeds, :url, unique: true
  end
end
