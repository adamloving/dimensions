class Admin::TagsController < Admin::BaseController
  respond_to :html, :json

  def index
    @tags = FeedEntry.tags(params[:feed_entry_id])
    respond_with @tags.tags
  end

  def delete
    @tags = FeedEntry.tags(params[:feed_entry_id])
    @tags.tags.delete(params[:tag_id])
    @tags.save
  end

end
