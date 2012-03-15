class FeedEntry < ActiveRecord::Base
  belongs_to :feed, class_name: NewsFeed, foreign_key: "news_feed_id"
  has_many :entities
  serialize :fetch_errors

  scope :failed, lambda{|is_fail| where(:failed => is_fail) }

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
      transition :new => :downloaded
      transition :downloaded => :fetched
      transition :fetched => :localized
      transition :localized => :tagged
    end
    event :untag do
      transition :tagged => :localized
    end

  end

  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    raise "The feed is invalid" if feed.nil?

    entries = []
    feed.entries.each do|entry|
      unless exists? guid: entry.id
        entries << create!(name: entry.title,
               summary: entry.summary,
               url: entry.url,
               published_at: entry.published,
               guid: entry.id,
               author: entry.author,
               content: entry.content)

      end
    end
    entries
  end

  def fetch_content!
    return self.content if self.content.present?

    begin
      scraper = Scraper.define do
        array :content

        process "p", :content => :text
        result :content
      end
      uri = URI.parse(self.url)
      self.content = scraper.scrape(uri).join(" ")
      self.save
      self.fetch
    rescue Exception => e
      self.fetch_errors = {:error => e.to_s}
      self.failed = true
      self.save
      return nil
    end

    return self.content
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

  def self.localize(entry)
    begin
      if entry.fetched?
        doc = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'])
        entry.published_at||= doc.doc_date

        unless doc.geographies.first.nil?
          entity = Dimensions::Locator.open_calais_location(doc.geographies)
          entry.entities << entity
          entry.localize
          entry.save
          return true
        end
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end
end
