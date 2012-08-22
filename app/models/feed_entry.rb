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

    entries = news_feed.add_entries(feed.entries)
  end

  def self.update_from_feed_continuously(feed_url)
    internal_feed = NewsFeed.find_by_url(feed_url)
    raise 'Couldn\'t find news feed with the given url' if internal_feed.blank?

    feed_to_update = internal_feed.atom_feed_object
    last_atom_entry = internal_feed.last_atom_feed_entry_object

    feed_to_update.entries = [last_atom_entry]

    updated_feed = Feedzirra::Feed.update(feed_to_update)

    return [] if invalid_feed?(updated_feed) || !updated_feed.updated?
    internal_feed.update_feed(updated_feed)
  end

  def self.invalid_feed? feed
    # Either the url is unreachable, it has a malformed url or it is not a feed
    feed == 0 || feed == []
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

    self.social_ranking = 0.0 if self.social_ranking.nil?

    if location["latitude"].present? && location["longitude"].present?
      doc_variables = { 0 => location["latitude"],
                        1 => location["longitude"],
                        2 => self.social_ranking}

      fields = {:url        => self.url,
                :timestamp  => self.published_at.to_i,
                :text       => self.name,
                :location   => self.primary_location.name,
                :tags       => self.tag_list.join(','),
                :all        => '1'}

      fields[:summary] = self.summary unless self.summary.nil?

      begin
        index.document(self.id).add(fields, :variables => doc_variables)
        self.update_attributes(failed: false, indexed: true)
        true
      rescue IndexTank::UnexpectedHTTPException
        self.update_attributes(failed: true, indexed: false)
        false
      end
    else
      self.update_attributes(failed: true)
      false
    end
  end

  def self.reindex_in_searchify(entry_id)
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    entry = self.find(entry_id)
    entry.index_in_searchify(index)
  end

  def re_index
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    self.index_in_searchify(index)
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

  def set_reviewed
    update_attribute :reviewed, true
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}" unless self.name.nil?
  end

  def update_tweet_count
    self.update_attributes(:tweet_count => (self.tweet_count += 1))
  end

  def self.add_tweet(tweet_urls = [])
    # tweet_urls = Array
    # tweet_urls => 0 o N urls
    unless tweet_urls.empty?
      tweet_urls.each do |url|
        entry = FeedEntry.where(:url => url["expanded_url"]).first
        entry.update_tweet_count if entry
      end
    end
  end

  def update_facebook_stats
    # ejecutar query a FB
    # update fb_count
    begin
      client = Koala::Facebook::API.new
      results = client.fql_query("
        SELECT url, normalized_url, like_count, share_count, comment_count
        FROM link_stat WHERE url='#{url.to_s}'").first

      self.update_attributes(
        :facebook_likes => results["like_count"],
        :facebook_shares => results["share_count"],
        :facebook_comments => results["comment_count"]
      )
      # self.update_attributes(:facebook_count => results.first["like_count"])
    rescue
      update_attribute :failed, true
      false
    end
  end

  def calculate_social_rank
    # Explainging the calculation
    # tweets, facebook likes and facebook shares = 1 upvote
    # facebook comments = 1/3 upvote

    # calculate upvotes and add 1 to avoid divide a zero by anything
    upvotes = ( tweet_count + facebook_likes + facebook_shares ) + ( facebook_comments / 3 ) + 1

    # calculate entry_age in hours and add 2 to avoid dividing by zero
    entry_age = ((Time.now - self.created_at) / 3600 ) + 2

    # calculate social_ranking using the entry rank coefficient (defaults to 1.8)
    # can be assigned per entry
    social_ranking = upvotes / ( entry_age ** self.rank_coefficient )
    self.update_attributes(:social_ranking => social_ranking)

    # rank = (tw + likes) - 1 / (time_since_post_date + 2) ** 1.8
    # upvotes = (self.tweet_count + self.facebook_count) - 1
    # social_ranking = upvotes / (entry_age ** 1.8 )
  end

  private

  def self.save_feedzirra_response(news_feed_id, feed)
    feedzirra_response = FeedzirraResponse.new(:serialized_response => {news_feed_id => feed}, :news_feed_id => news_feed_id)
    feedzirra_response.save
  end

end
