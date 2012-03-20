class CreateEntitiesFeedEntriesJoinTable < ActiveRecord::Migration
  def up
    create_table :entities_feed_entries, :id => false do |t|
      t.integer :entity_id
      t.integer :feed_entry_id
    end
    
    remove_column :entities, :feed_entry_id
  end 

  def down
    raise  ActiveRecord::IrreversibleMigration
  end
end
