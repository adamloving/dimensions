class FeedEntry < ActiveRecord::Base
  belongs_to  :feed, class_name: NewsFeed, foreign_key: "news_feed_id"
  has_many    :entity_feed_entries
  has_many    :entities, :through => :entity_feed_entries do
    def primary
     where("entity_feed_entries.default = ?", true)
    end

    def secondary
     where("entity_feed_entries.default = ?", false)
    end
  end

  serialize :fetch_errors

  default_scope order('id DESC')

  scope :failed, lambda{|is_fail| where(:failed => is_fail) }
  scope :for_location_review, where(:state => ['localized', 'tagged'])
  scope :not_reviewed, where(:reviewed => false)
  scope :reviewed, where(:reviewed => true)

  acts_as_taggable

  state_machine :initial => :new do

    event :download do
      transition :new => :downloaded
    end

    event :fetch do
      transition :downloaded => :fetched
    end

    event :localize do
      transition :fetched => :localized
    end

    event :tag do
      transition :localized => :tagged
    end

    event :next do
      transition :new         => :downloaded
      transition :downloaded  => :fetched
      transition :fetched     => :localized
      transition :localized   => :tagged
    end

    event :untag do
      transition :tagged => :localized
    end

    after_transition :on => :fetch, :do => :fetch_content!
    after_transition :on => :download, :do => :enqueue_to_fetch
    after_transition :on => :localize, :do => :enqueue_to_tag
    after_transition :on => :tag, :do => :index_this_entry
  end

  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    raise "The feed is invalid" if feed.blank?

    news_feed = NewsFeed.find_by_url(feed_url)
    news_feed.update_attributes(:etag => feed.etag, :last_modified => feed.last_modified)

    entries = add_entries(feed.entries, news_feed.id)
  end

  def self.update_from_feed_continuously(feed_url)
    internal_feed = NewsFeed.find_by_url(feed_url)
    raise 'Couldn\'t find news feed with the given url' if internal_feed.blank?

    feed_to_update                = Feedzirra::Parser::Atom.new.tap do|feed|
      feed.feed_url       = internal_feed.url
      feed.etag           = internal_feed.etag
      feed.last_modified  = internal_feed.last_modified
    end

    last_entry      = Feedzirra::Parser::AtomEntry.new
    last_entry.url  = internal_feed.entries.last

    feed_to_update.entries = [last_entry]

    updated_feed = Feedzirra::Feed.update(feed_to_update)


    if updated_feed.updated?
      add_entries updated_feed.new_entries, internal_feed.id 
      internal_feed.update_attributes!(:etag => updated_feed.etag, :last_modified => updated_feed.last_modified)
    end
  end

  def self.localize(entry)
    if entry.fetched?
      doc = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'])
      entry.published_at||= doc.doc_date

      entry.entities.push(entry.feed.location)
      entry.primary_location = entry.feed.location

      unless doc.geographies.empty?
        #test no location is returned as nil!
        locations = Dimensions::Locator.parse_locations(doc.geographies)

        unless locations.empty?
          locations.each {|location| entry.entities << location unless location.nil?}
          entry.primary_location = locations.first if locations.first.present? &&  !locations.first.new_record?
        end
      end
      entry.localize
      entry.save!
      return true
    end
  end

  def self.batch_localize
    begin
      self.find_each do |entry|
        self.localize(entry)
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def enqueue_to_fetch
    Resque.enqueue(EntryContentFetcher, self.id)
  end

  def enqueue_to_tag
    Resque.enqueue(EntryTagger, self.id)
  end

  def index_this_entry
    Resque.enqueue(EntryIndexer, self.id)
  end

  def fetch_content!
    if self.content.present?
      Resque.enqueue(EntryLocalizer, self.id)
      return self.content
    end

    begin
      scraper = Scraper.define do
        array :content

        process "p", :content => :text
        result :content
      end
      uri = URI.parse(self.url)
      self.content = scraper.scrape(uri).join(" ").safe_encoding
      self.save
      Resque.enqueue(EntryLocalizer, self.id)
    rescue Exception => e
      self.fetch_errors = {:error => e.to_s.safe_encoding}
      self.failed = true
      self.save
      return nil
    end
    self.content
  end

  def index_in_searchify(index)
    location = self.primary_location.serialized_data
    if location["latitude"].present? && location["longitude"].present?
      doc_variables = { 0 => location["latitude"],
                        1 => location["longitude"],
                        2 => self.published_at.to_i }

      fields = {:url        => self.url, 
                :timestamp  => self.published_at.to_i,
                :text       => self.name,
                :location   => self.primary_location.name,
                :tags       => self.tag_list.join(','),
                :all        => '1'}

      fields.merge(:summary => self.summary) unless self.summary.nil?

      index.document(self.id).add(fields, :variables => doc_variables)
      self.update_attributes(:indexed => true)
      true
    else
      false
    end
  end

  def self.reindex_in_searchify(entry_id)
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    entry = self.find(entry_id)
    entry.index_in_searchify(index)
  end

  def locations
    self.entities.location
  end

  def primary_location
    self.entities.location.primary.first
  end

  def primary_location=(location)
    self.entity_feed_entries.all.each do|join_object|
      join_object.update_attributes(:default => false)
    end
    join_object = self.entity_feed_entries.find_by_entity_id(location.id)
    join_object.update_attributes(:default => true)
  end

  def secondary_locations
    self.entities.location.secondary
  end

  def self.batch_tag
    begin
      self.find_each do |entry|
        self.tag(entry)
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def self.tag(entry)
    if entry.localized?
      doc = Calais.process_document content: entry.content,
                                    content_type: :raw,
                                    license_id: APP_CONFIG['open_calais_api_key']
      if doc.categories.present?
        entry.tag_list = Dimensions::Tagger.open_calais_tag(doc.categories, doc.entities)
        entry.tag
        entry.save
        return true
      end
    end
  end

  #def tags
    #return nil if self.get_tags.blank?
    #twitags = self.get_tags.tags.map{|tag| '#' + tag.titleize.gsub(' ', '')}
    #twitags.uniq.join(' ')
  #end

  #def self.tags(id)
    #self.find(id).entities.tag.first
  #end

  #def get_tags
    #self.entities.tag.first
  #end

  def set_reviewed
    update_attribute :reviewed, true
  end

  private 
  def self.add_entries(feed_entries=[], news_feed_id)
    entries = []
    feed_entries.each do|entry|
      if entry.id.class == String
        unless exists? guid: entry.id
          entries << create!(name: entry.title,
                 summary: entry.summary,
                 url: entry.url,
                 published_at: entry.published,
                 guid: entry.id,
                 author: entry.author,
                 news_feed_id: news_feed_id,
                 content: entry.content)
        end
      end
    end
    entries
  end

  def self.save_feedzirra_response(news_feed_id, feed)
    feedzirra_response = FeedzirraResponse.new(:serialized_response => {news_feed_id => feed}, :news_feed_id => news_feed_id)
    feedzirra_response.save
  end
end
