class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :type
      t.string :attributes

      t.timestamps
    end
  end
end
