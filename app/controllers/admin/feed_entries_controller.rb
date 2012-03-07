class Admin::FeedEntriesController < Admin::BaseController
  before_filter :find_feed

  def index
    @feed_entries = @news_feed.entries
  end

  def new
    @feed_entry = @news_feed.entries.build
  end

  def create
    @feed_entry = @news_feed.entries.build(params[:feed_entry])

    if @feed_entry.save
      redirect_to admin_news_feed_feed_entries_path(@news_feed)
    else
      render :new
    end
  end

  def edit
    @feed_entry = @news_feed.entries.find(params[:id])
  end

  def update
    @feed_entry = @news_feed.entries.find(params[:id])
   
    if @feed_entry.update_attributes(params[:feed_entry])
      redirect_to admin_news_feed_feed_entries_path(@news_feed)
    else
      render :edit
    end
  end

  def show
    @feed_entry = @news_feed.entries.find(params[:id])
  end

  def toggle_visible
    entry = @news_feed.entries.find(params[:id])
    entry.toggle(:visible)
    entry.save
    redirect_to admin_news_feed_feed_entry_path(@news_feed, entry)
  end

  def fetch_content
    entry = @news_feed.entries.find(params[:id])
    if entry.fetch_content!.present?
      entry.save
      flash[:notice] = "Loaded entry's content successfully"
    else
      flash[:errors] = "We had an error fetching your content"
    end
    redirect_to admin_news_feed_feed_entry_path(@news_feed, entry)
  end

  def destroy
    entry = @news_feed.entries.find(params[:id])
    entry.destroy
    redirect_to admin_news_feed_feed_entries_path(@news_feed)
  end

  private

  def find_feed
    @news_feed = NewsFeed.find(params[:news_feed_id])
  end
end
