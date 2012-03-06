ActiveAdmin.register NewsFeed do
  form do |f|
    f.semantic_errors :name
    f.semantic_errors :url

    f.inputs "Manage Feeds" do
      f.input :name
      f.input :url
    end
    f.buttons
  end

  index do
    column :name
    column :url
    column :created_at
    column :updated_at
    default_actions
    column do |news_feed|
      link_to "entries", admin_feed_entries_path(:q=> {:news_feed_id_eq => news_feed.id})
    end
  end
end
