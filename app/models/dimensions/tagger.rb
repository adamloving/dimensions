class Dimensions::Tagger
  def self.open_calais_tag(categories, entities, name)
    tags = [categories.first.name]

    entities.each do |entity|
      unless entity.attributes["name"].length > 30
        tags << entity.attributes["name"]
      end
    end

    entity = Entity.find_or_initialize_by_name(:name => name).tap do|e|
      e.tags = tags
      e.type = "tag"
    end
  end
end
