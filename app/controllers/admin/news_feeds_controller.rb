class Admin::NewsFeedsController < Admin::BaseController
  before_filter :find_the_news_feed, :only => [:edit, :update, :show]

  def index
    @news_feeds = NewsFeed.all
  end

  def new
    @news_feed = NewsFeed.new
  end

  def create
    @news_feed = NewsFeed.new(params[:news_feed])
    if @news_feed.save
      redirect_to admin_news_feeds_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @news_feed.update_attributes(params[:news_feed])
      redirect_to admin_news_feeds_path
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
  end

  private

  def find_the_news_feed
    @news_feed = NewsFeed.find(params[:id])
  end
end
