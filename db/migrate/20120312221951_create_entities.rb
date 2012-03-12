class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :type
      t.string :serialized_data
      t.timestamps
    end
  end
end
