class Api::TagsController < ApplicationController
  respond_to :json

  def index
    @tags = FeedEntry.tag_counts.order('count DESC').limit(10)
    respond_with @tags
  end
end
