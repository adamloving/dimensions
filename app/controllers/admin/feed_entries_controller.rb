class Admin::FeedEntriesController < Admin::BaseController
  before_filter :find_feed, :except => [:index, :search, :review_locations, :set_primary_location]

  def index
    @feed_entries = if params[:news_feed_id]
      NewsFeed.find(params[:news_feed_id]).entries.page(params[:page]).per(20)
    else
      FeedEntry.page(params[:page]).per(20)
    end
  end

  def review_locations
    @feed_entries = if params[:news_feed_id]
      NewsFeed.find(params[:news_feed_id]).entries.for_location_review.page(params[:page]).per(20)
    elsif params[:reviewed] == 'true'
      @feed_entries = FeedEntry.reviewed.for_location_review.page(params[:page]).per(20)
    else
      @feed_entries = FeedEntry.not_reviewed.for_location_review.page(params[:page]).per(20)
    end
  end

  def new
    @feed_entry = @news_feed.entries.build
  end

  def create
    @feed_entry = @news_feed.entries.build(params[:feed_entry])

    if @feed_entry.save
      flash[:notice] = "News Feed entry was successfully created"
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
      flash[:notice] = "News Feed entry was successfully updated"
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

  def set_primary_location
    entry     = FeedEntry.find(params[:feed_entry_id])
    location  = entry.locations.find(params[:location_id])
    entry.primary_location = location

    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_indices']['locations'])
    entry.index_in_searchify index
    entry.set_reviewed

    respond_to do |format|
      format.js { render :json=> {:location=>location, :entry=>params[:feed_entry_id]}}
    end
  end

  def fetch_content
    entry = @news_feed.entries.find(params[:id])
    Resque.enqueue(EntryContentFetcher, entry.id)

    if entry.save
      flash[:notice]  = "Entry successfully processed"
    else
      flash[:error]   = "There was an error saving the entry"
    end
    redirect_to admin_news_feed_feed_entry_path(@news_feed, entry)
  end

  def process_entry
    entry = @news_feed.entries.find(params[:id])
    case params[:current]
    when "fetched"
      Resque.enqueue(EntryLocalizer, entry.id)
      flash[:notice] = "Feed Entry successfully localized"
    end

    redirect_to admin_news_feed_feed_entry_path(@news_feed, entry)
  end

  def destroy
    entry = @news_feed.entries.find(params[:id])
    entry.destroy
    flash[:notice] = "Entry successfully destroyed"
    redirect_to admin_news_feed_feed_entries_path(@news_feed)
  end

  def search
    @search = FeedEntry.search(params[:q])
    @feed_entries = @search.page(params[:page]).per(20)
    render :index
  end

  def re_index
    if FeedEntry.reindex_in_searchify(params[:id])
      redirect_to admin_news_feed_feed_entry_path(@news_feed, params[:id])
      flash[:notice]="Entry succesfully re-indexed"
    else
      flash[:alert]="Ups! Something went wrong, try again..."
      redirect_to :admin_news_feeds
    end
  end

  private

  def find_feed
    @news_feed = NewsFeed.find(params[:news_feed_id])
  end
end
