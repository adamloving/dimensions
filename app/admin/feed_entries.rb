ActiveAdmin.register FeedEntry do
  index :as => :blog do
    title :name # Calls #my_title on each resource
    body  :summary  # Calls #my_body on each resource
  end

  controller do
    def index
      index! do|format|
        @search = FeedEntry.search(params[:q])
        @feed_entries = @search.page(params[:page]).per(20)
      end
    end
  end
end
