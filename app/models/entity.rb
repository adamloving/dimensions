class Entity < ActiveRecord::Base
  belongs_to  :feed_entry
  belongs_to  :news_feed

  serialize   :serialized_data, Hash

  # we fucked up with the naming of the STI names.
  Entity.inheritance_column= "ruby_type"

  scope :locations, where(:type => "location")
end
