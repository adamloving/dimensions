class Admin::TrendsController < Admin::BaseController

  def index
    @trends = FeedEntry.tag_counts.where('tags.blacklisted = false').order('count DESC').limit(20)
  end

  def blacklist
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.blacklist!
    redirect_to admin_trends_path
  end
end
