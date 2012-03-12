class Admin::FeedEntriesController < Admin::BaseController
  before_filter :find_feed, :except => [:index, :search]

  def index
    #@feed_entries = @news_feed.entries
    @feed_entries = if params[:news_feed_id]
      NewsFeed.find(params[:news_feed_id]).entries.page(params[:page]).per(20)
    else
      FeedEntry.page(params[:page]).per(20)
    end
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
      data = {:message => "we successfully processed your entry", :content => entry.content}
    else
      data = {:message => "we couldn't process your entry", :error => entry.fetch_errors.values}
    end
    render :json => data
  end

  def process_entry
    entry = @news_feed.entries.find(params[:id])
    case params[:current]
    when "fetched"
      FeedEntry.localize(entry.id)
    end
    redirect_to admin_news_feed_feed_entry_path(@news_feed, entry)
  end

  def destroy
    entry = @news_feed.entries.find(params[:id])
    entry.destroy
    redirect_to admin_news_feed_feed_entries_path(@news_feed)
  end

  def search
    @search = FeedEntry.search(params[:q])
    @feed_entries = @search.page(params[:page]).per(20)
    render :index
  end

  private

  def find_feed
    @news_feed = NewsFeed.find(params[:news_feed_id])
  end
end
