ActiveAdmin.register FeedEntry do
  actions :index, :show

  index :as => :blog do
    title :name # Calls #my_title on each resource
    body  :summary  # Calls #my_body on each resource
  end
end
