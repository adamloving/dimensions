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
end
