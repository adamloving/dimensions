class Entity < ActiveRecord::Base
  belongs_to :FeedEntry
  serialize :serialized_data, Hash
  set_inheritance_column :ruby_type
end
