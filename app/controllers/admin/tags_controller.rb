class Admin::TagsController < Admin::BaseController
  respond_to :html, :json

  def index
    @feed_entry = FeedEntry.find(params[:feed_entry_id])
    @tags = FeedEntry.tags(params[:feed_entry_id]).tags
    respond_with @tags
  end

  def delete
    @tags = FeedEntry.tags(params[:feed_entry_id])
    @tags.tags.delete(params[:tag_id])
    @tags.save
  end

end
