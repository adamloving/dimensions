class Entity < ActiveRecord::Base
  belongs_to :FeedEntry
  serialize :serialized_data, Hash
end
