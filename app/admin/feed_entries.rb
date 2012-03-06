ActiveAdmin.register FeedEntry do
  index :as => :blog do
    title :name # Calls #my_title on each resource
    body  :summary  # Calls #my_body on each resource
  end

  show do |ad|
    attributes_table do
      row :id
      row :name
      row :summary
      row :url
      row :published_at
      row :guid
      row :author
      row :content
      row :created_at
      row :updated_at
      row :news_feed_id
      row :"show / hide" do|feed_entry|
        link_to feed_entry.visible? ? "Hide" : "Show", toggle_visible_admin_feed_entry_path(feed_entry), :method => :put
      end
    end

    active_admin_comments
  end

  member_action :toggle_visible, :method => :put do
    feed_entry = FeedEntry.find(params[:id])
    feed_entry.toggle(:visible)
    feed_entry.save
    redirect_to({:action => :show}, :notice => "The entry is now " + (feed_entry.visible? ? "shown" : "hidden"))
  end

end
