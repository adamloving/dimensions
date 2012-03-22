class Admin::TagsController < Admin::BaseController
  respond_to :json

  def index
    @tags = FeedEntry.tags(params[:id])
    respond_with @tags.tags
  end

  def destroy
    @tags = FeedEntry.tags(params[:id])
    @tags.tags.delete(params[:tag])
    @tags.save
    redirect_to :home
  end

end
