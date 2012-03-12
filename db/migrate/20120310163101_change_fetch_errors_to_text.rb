class ChangeFetchErrorsToText < ActiveRecord::Migration
  def up
    change_column :feed_entries, :fetch_errors, :text
  end

  def down
    change_column :feed_entries, :fetch_errors, :string
  end
end
