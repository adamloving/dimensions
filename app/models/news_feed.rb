require 'dimensions/netutils'

class NewsFeed < ActiveRecord::Base
  include Dimensions::Netutils
  has_and_belongs_to_many   :entities
  has_many                  :entries, :class_name =>  FeedEntry, :dependent => :restrict


  attr_accessor :location_values

  validates :name, :url, presence: true

  validates_uniqueness_of :name, :url


  before_save :url_connection_valid? unless Rails.env.test?

  before_save :build_location

  def load_entries
    entries = FeedEntry.update_from_feed(self.url)
    self.entries += entries
    self.save
    entries.each do|entry|
      entry.feed = self
      self.entries << entry
      entry.download
    end
  end

  def process_entries
    entries.each do |entry|
      entry.next
    end
  end

  
  def location
    return nil if self.entities.blank?
    self.entities.location.first
  end

  def location_values
    @location_values ||= {:serialized_data => {}}
  end

  def address=(address)
    location_values[:name] = address
  end

  def address
    return "" if self.location.nil?
    self.location.name 
  end

  def location_latitude
    return "" if self.location.nil?
    self.location.serialized_data['latitude']
  end

  def location_latitude=(latitude)
    location_values[:serialized_data]['latitude'] = latitude
  end

  def location_longitude
    return "" if self.location.nil?
    self.location.serialized_data['longitude']
  end

  def location_longitude=(longitude)
    location_values[:serialized_data]['longitude'] = longitude
  end

  private

  def build_location
    location = self.entities.find_by_type('location')
    if location
      location.update_attributes(location_values.merge(:type => 'location'))
    else
      self.entities << Entity.create(location_values.merge(:type => 'location')) unless location_values.except(:serialized_data).blank?
    end
  end
end
