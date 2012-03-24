class Admin::TagsController < Admin::BaseController
  respond_to :html, :json

  def index
    @feed_entry = FeedEntry.find(params[:feed_entry_id])
    respond_with @feed_entry.get_tags
  end

  def delete
    feed_entry = FeedEntry.find(params[:feed_entry_id])
    tag = feed_entry.get_tags
    tag.clear_tag(params[:tag])
    tag.save
    respond_to do |format|
      format.js { render :json=> {:tag=>params[:tag]}}
    end
  end
end
