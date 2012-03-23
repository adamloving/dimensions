class AddTagsToEntities < ActiveRecord::Migration
  def up
    add_column :entities, :tags, :text
  end
  def down
    remove_column :entities, :tags
  end
end
