class Dimensions::Tagger
  def self.open_calais_tag(categories, entities)
    tags = [categories.first.name]

    entities.each do |entity|
      new_tag = entity.attributes["name"]
      next unless new_tag
      tags << new_tag if new_tag.length <= 30
    end

    tags
  end
end
