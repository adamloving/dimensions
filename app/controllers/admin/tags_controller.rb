class Admin::TagsController < Admin::BaseController
  respond_to :html, :json

  def index
    @feed_entry = FeedEntry.find(params[:feed_entry_id])
    respond_with @feed_entry.get_tags
  end

  def delete
    feed_entry = FeedEntry.find(params[:feed_entry_id]).tap do|fe|
      fe.tag_list = fe.tag_list - [params[:tag]]
      fe.save
    end
    respond_to do |format|
      format.js { render :json=> {:tag=>params[:tag]}}
    end
  end
end
