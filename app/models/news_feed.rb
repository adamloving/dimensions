require 'dimensions/netutils'

class NewsFeed < ActiveRecord::Base
  include Dimensions::Netutils

  has_many :entries, class_name: FeedEntry
  validates :name, :url, presence: true


  before_save :url_connection_valid?

  def load_entries
    entries = FeedEntry.update_from_feed(self.url)
    entries.each do|entry|
      entry.feed = self
      self.entries << entry
    end
  end
end
