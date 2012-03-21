class RemoveEntitiesFeedEntriesJoinTableAndRemoveDefaultFromEntities < ActiveRecord::Migration
  def up
    drop_table    :entities_feed_entries
    remove_column :entities, :default 
  end

  def down
    raise  ActiveRecord::IrreversibleMigration
  end
end
