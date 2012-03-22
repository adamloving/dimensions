class Admin::TagsController < Admin::BaseController
  respond_to :json

  def index
    @tags = FeedEntry.tags(params[:id])
    respond_with @tags.first.tags
  end

  def destroy
  end

end
