class Admin::NewsFeedsController < Admin::BaseController
  before_filter :find_the_news_feed, :only => [:edit, :update, :show, :load_entries, :destroy, :process_entries]

  def index
    @news_feeds = NewsFeed.all
  end

  def new
    @news_feed = NewsFeed.new
  end

  def create
    @news_feed = NewsFeed.new(params[:news_feed])
    if @news_feed.save
      flash[:notice] = "News Feed successfully created"
      redirect_to admin_news_feeds_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @news_feed.update_attributes(params[:news_feed])
      flash[:notice] = "News Feed successfully updated"
      redirect_to admin_news_feeds_path
    else
      render 'edit'
    end
  end

  def show
  end
  
  def load_entries
    begin
      @news_feed.bg_load_entries
      flash[:notice] = "We are processing the feeds for '#{@news_feed.name}'..."
      redirect_to :action => :index
    rescue Exception => e
      render :text => "We have had errors loading your feed: #{e.to_s}"
    end
  end

  def process_entries
      flash[:notice] = "Feed entries processed"
      @news_feed.process_entries
      redirect_to :back
  end

  def destroy
    begin
      @news_feed.destroy
      flash[:notice] = "Feed #{@news_feed.name} destroyed"
      redirect_to admin_news_feeds_path
    rescue Exception => e
      flash[:error] = "The feed can't be destroyed because it has associated entries"
      redirect_to admin_news_feeds_path
    end
  end

  def search
    @search = NewsFeed.search(params[:q])
    @news_feeds = @search.page(params[:page]).per(20)
    render :index
  end

  private

  def find_the_news_feed
    @news_feed = NewsFeed.find(params[:id])
  end
end
