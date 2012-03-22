class Dimensions::Tagger
  def self.open_calais_tag(categories, entities, name)
    tags = Array.new
    tags.push(categories.first.name)
    entities.each do |entity|
      unless entity.attributes["name"].length > 30
        tags.push(entity.attributes["name"])
      end
    end
    entity = Entity.new(:name => name, :tags => tags, :type => "tags")
  end
end
