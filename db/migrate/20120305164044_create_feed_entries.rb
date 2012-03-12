class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string    :name
      t.text      :summary
      t.string    :url
      t.datetime  :published_at
      t.string    :guid
      t.string    :author
      t.text    :content
      t.timestamps
    end

    add_index :feed_entries, :url, unique: true
  end
end
