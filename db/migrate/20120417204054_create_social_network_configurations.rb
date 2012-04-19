class CreateSocialNetworkConfigurations < ActiveRecord::Migration
  def up
    create_table :social_network_configurations do|t|
      t.string    :name
      t.text      :message

      t.timestamps
    end
  end

  def down
    drop_table :social_network_configurations
  end
end
