class EntryLocalizer
  @queue = :entries

  def self.perform(entry_id)
    entry = FeedEntry.find(entry_id)
    begin
      if entry.fetched?
        doc = Calais.process_document(:content => entry.content, :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'])
        entry.published_at||= doc.doc_date

        entry.entities.push(entry.feed.location)
        entry.primary_location = entry.feed.location

        unless doc.geographies.empty?
          locations = Dimensions::Locator.parse_locations(doc.geographies)
          entry.entities = locations
          entry.primary_location = locations.first
        end

        entry.localize
        entry.save
        return true
      end
    rescue Exception => e
      return nil
    end
  end
end
