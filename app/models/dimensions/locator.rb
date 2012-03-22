class Dimensions::Locator
  def self.open_calais_location(geographies)
    geography = geographies.first
    serialized_data = geography.attributes.except("docId")
    entity = Entity.new(:name => geography.name, :serialized_data => serialized_data, :type => "location")
  end

  def self.parse_locations(geographies)
    locations = geographies.map do|geography|
      if geography.attributes["longitude"] && geography.attributes["latitude"]
        serialized_data = geography.attributes.except("docId")
        Entity.find_or_initialize_by_name(:name => geography.name, :serialized_data => serialized_data, :type => "location")
      end
    end
  end
end
