class CreateEntitiesNewsFeedsJoinTable < ActiveRecord::Migration
  def up
    create_table :entities_news_feeds, :id => false do |t|
      t.integer :entity_id
      t.integer :news_feed_id
    end
    
    remove_column :entities, :news_feed_id
  end 

  def down
    raise  ActiveRecord::IrreversibleMigration
  end
end
