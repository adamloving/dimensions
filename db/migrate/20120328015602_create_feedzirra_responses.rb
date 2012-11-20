class CreateFeedzirraResponses < ActiveRecord::Migration
  def change
    create_table :feedzirra_responses do |t|
      t.integer :news_feed_id
      t.text :serialized_response

      t.timestamps
    end
  end
end
