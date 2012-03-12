class AddColumnsToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :feed_entry_id, :integer
  end
end
