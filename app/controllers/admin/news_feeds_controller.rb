class Admin::NewsFeedsController < Admin::BaseController
  before_filter :find_the_news_feed, :only => [:edit, :update, :show, :load_entries]

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
  
  def load_entries
    begin
      @news_feed.load_entries
      render :text => "We have successfully loaded your news feed"
    rescue Exception => e
      render :text => "We have had errors loading your feed: #{e.to_s}"
    end
  end

  def destroy
  end

  private

  def find_the_news_feed
    @news_feed = NewsFeed.find(params[:id])
  end
end
