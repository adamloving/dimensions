class Dimensions::Tagger
  def self.open_calais_tag(categories, entities)
    tags = [categories.first.name]

    entities.each do |entity|
      unless entity.attributes["name"].length > 30
        tags << entity.attributes["name"]
      end
    end

    tags
  end
end
