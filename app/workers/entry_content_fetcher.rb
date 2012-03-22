class EntryContentFetcher
  @queue = :entries

  def self.perform(entry_id)
    entry = FeedEntry.find_by_id(entry_id)

    begin
      scraper = Scraper.define do
        array :content

        process "p", :content => :text
        result :content
      end
      uri = URI.parse(entry.url)
      entry.content = scraper.scrape(uri).join(" ")
      entry.save
    rescue Exception => e
      entry.fetch_errors = {:error => e.to_s}
      entry.failed = true
      entry.save
      return nil
    end
  end
end
