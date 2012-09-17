require 'dimensions/netutils'
require 'net/http'
require 'uri'

class NewsFeed < ActiveRecord::Base
  include Dimensions::Netutils

  has_and_belongs_to_many :entities
  has_many  :entries, :class_name =>  FeedEntry, :dependent => :restrict
  has_one :feedzirra_response

  attr_accessor :location_values

  validates :name, :url, presence: true

  validates_uniqueness_of :name, :url


  after_create  :enqueue_entries_loading
  before_save   :url_connection_valid? unless Rails.env.test?
  before_save   :build_location

  def self.set_downloaded(entries)
    entries.each {|e| e.download}
  end

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
    if !!entries
      NewsFeed.set_downloaded(entries)
    else
      false
    end
  end

  def update_entries
    unless self.entries.empty?
      new_entries = FeedEntry.update_from_feed_continuously(self.url)
      NewsFeed.set_downloaded(entries) unless new_entries.blank?
    else
      self.load_entries
    end
  end

  def atom_feed_object
    news_feed = self
    Feedzirra::Parser::Atom.new.tap do |atom_feed|
      atom_feed.feed_url       = news_feed.url
      atom_feed.etag           = news_feed.etag
      atom_feed.last_modified  = news_feed.last_modified
    end
  end

  def last_atom_feed_entry_object
    last_atom_entry = Feedzirra::Parser::AtomEntry.new.tap do |atom_feed_entry|
      atom_feed_entry.url = entries.last.url
    end
  end

  def update_feed(updated_feed)
    begin
    update_attributes!(
      etag: updated_feed.etag,
      last_modified: updated_feed.last_modified
    )
    add_entries(updated_feed.new_entries)
    rescue Exception => e
      add_entries(updated_feed.new_entries)
      puts "Failed to update feed, details: #{e.to_s}"
    end
  end

  def add_entry(entry)
    begin
      @entries << FeedEntry.create!(name: entry.title,
                                   summary: entry.summary,
                                   url: fetch(entry.url),
                                   published_at: entry.published,
                                   guid: entry.id,
                                   author: entry.author,
                                   news_feed_id: self.id,
                                   content: entry.content)
    rescue Exception => e
      puts "Failed to create entries, details: #{e.to_s}"
    end
  end

  def add_entries(feed_entries=[])
    @entries = []
    feed_entries.each do |entry|
      next unless entry.id.class == String && !FeedEntry.exists?(guid: entry.id)
      add_entry entry
    end
    @entries
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

  def bg_reindex_feed
    Resque.enqueue(ReindexFeed, self.id)
  end

  def reindex_feed
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    if self.valid_feed?
      self.entries.each { |entry| entry.index_in_searchify(index) if entry.tagged? and !entry.indexed }
    else
      false
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
  
  def fetch(uri_str)
    begin
      response = Net::HTTP.get_response(URI.parse(uri_str))
      if response.class == Net::HTTPOK
        url = uri_str
      else
        url = response['location']
      end
      url.slice(/^.+\?/)[0..-2]
    rescue Exception => e
      uri_str
    end
  end
end
