class AddBlacklistedToTags < ActiveRecord::Migration
  def change
    add_column :tags, :blacklisted, :boolean, default: false


  end
end
