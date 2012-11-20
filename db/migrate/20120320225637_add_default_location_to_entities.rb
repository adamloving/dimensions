class AddDefaultLocationToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :default, :boolean, :default => false
  end
end
