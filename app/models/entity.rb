class Entity < ActiveRecord::Base
  belongs_to  :feed_entry
  serialize   :serialized_data, Hash

  Entity.inheritance_column= "ruby_type"
  scope :locations, where(:type => "location")
end
