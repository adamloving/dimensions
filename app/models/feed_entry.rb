class FeedEntry < ActiveRecord::Base
  belongs_to :feed, class_name: NewsFeed, foreign_key: "news_feed_id"

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
    scraper = Scraper.define do
      array :content

      process "p", :content => :text
      result :content
    end
    uri = URI.parse(self.url)
    self.content = scraper.scrape(uri).join(" ")
  end
end
