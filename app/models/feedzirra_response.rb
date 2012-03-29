class FeedzirraResponse < ActiveRecord::Base
  belongs_to :news_feed

  serialize :serialized_response, Hash
end
