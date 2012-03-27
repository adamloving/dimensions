require 'dimensions/netutils'

class NewsFeed < ActiveRecord::Base
  include Dimensions::Netutils

  has_and_belongs_to_many :entities
  has_many  :entries, :class_name =>  FeedEntry, :dependent => :restrict


  attr_accessor :location_values

  validates :name, :url, presence: true

  validates_uniqueness_of :name, :url


  after_create  :enqueue_entries_loading
  before_save   :url_connection_valid? unless Rails.env.test?
  before_save   :build_location


  def address
    return "" if self.location.nil?
    self.location.name 
  end

  def address=(address)
    location_values[:name] = address
  end

  def bg_load_entries
    Resque.enqueue(FeedLoader, self.id)
  end

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
  
  def location
    return nil if self.entities.blank?
    self.entities.location.first
  end

  def location_values
    @location_values ||= {:serialized_data => {}}
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

  def process_entries
    entries.each do |entry|
      entry.next
    end
  end

  private

  def build_location
    location = self.entities.find_by_type('location')

    if location_values[:serialized_data].present? && (!location_values[:serialized_data]['longitude'].blank? && !location_values[:serialized_data]['latitude'].blank?) 
      if location
        location.update_attributes( :serialized_data  => location_values[:serialized_data],
                                    :name =>location_values[:name])
      else
        self.entities = [Entity.create(location_values.merge(:type => 'location'))]
      end
    end
  end

  def enqueue_entries_loading
    Resque.enqueue(FeedLoader, self.id)
  end
end
