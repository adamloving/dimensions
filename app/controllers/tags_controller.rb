class TagsController < ApplicationController
  respond_to :json

  def index
    #TODO This tags should be given the functionality to be served base on how much they have been searched or any other trend
    tag_entities = Entity.tag.limit(10)
    tags = []

    tag_entities.map(&:as_twitter_tag_list).each do|tag_list|
      tags << tag_list
    end

    tags = tags.flatten.uniq
    respond_with tags
  end
end
