class FeedEntry < ActiveRecord::Base
  belongs_to :feed, class_name: NewsFeed, foreign_key: "news_feed_id"
  serialize :fetch_errors

  state_machine :initial => :loaded do

    event :fetch do
      transition :loaded => :fetched
    end

    event :localize do
      transition :fetched => :localized
    end

    event :tag do
      transition :localized => :tagged
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
    rescue Exception => e
      self.fetch_errors = {:error => e.to_s}
      return nil
    end

    return self.content
  end

  def self.get_location
    begin
      entries = self.all

      entries.each do |e|
        if e.fetched?
          unless e.localized?
            location = Calais.process_document(:content => e.content, :content_type => :raw, :license_id => "du295ff4zrg3rd4bwdk86xhy")
            unless location.geographies.first == nil
              e.shortname = location.geographies.first.attributes["shortname"]
              e.country = location.geographies.first.attributes["containedbycountry"]
              e.latitude = location.geographies.first.attributes["latitude"]
              e.longitude = location.geographies.first.attributes["longitude"]
              e.localize
              e.save
            end
          end
        end
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end

  def self.get_location_by_id(id)
    begin
      entry = self.find(id)
      if entry.fetched?
        unless entry.localized?
          location = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => "du295ff4zrg3rd4bwdk86xhy")
          unless location.geographies.first == nil
            entry.shortname = location.geographies.first.attributes["shortname"]
            entry.country = location.geographies.first.attributes["containedbycountry"]
            entry.latitude = location.geographies.first.attributes["latitude"]
            entry.longitude = location.geographies.first.attributes["longitude"]
            entry.localize
            entry.save
          end
        end
      end
    rescue Exception => e
      puts e.to_s
      return nil
    end
  end
end
