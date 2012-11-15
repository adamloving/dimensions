class AddDefaultCoefficientToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :rank_coefficient, :float, {:length => 7, :decimals => 4, :default => 1.8000}
  end
end
