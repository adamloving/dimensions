class AddSocialRankingToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :social_ranking, :float, {:length => 15, :decimals => 10}
  end
end
