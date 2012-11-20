class CreateEntityFeedEntriesTable < ActiveRecord::Migration
  def up
    create_table :entity_feed_entries do |t|
      t.integer :entity_id
      t.integer :feed_entry_id
      t.boolean :default, :default => false
    end
  end

  def down
    drop_table :entity_feed_entries
  end
end
