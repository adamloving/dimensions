class EntityFeedEntry < ActiveRecord::Base
  belongs_to  :entity
  belongs_to  :feed_entry 
end
