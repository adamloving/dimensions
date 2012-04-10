class Api::TagsController < ApplicationController
  respond_to :json

  def index
    @tags = FeedEntry.tag_counts.where('blacklisted = false').order('count DESC').limit(10)
    respond_with @tags
  end
end
