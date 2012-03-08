FactoryGirl.define do
  factory :feed_entry do
    name          "The first post"
    summary       'I was so lazy to write my first post' 
    sequence :url do |n|
      "/some_url-#{n}"
    end
    published_at  Time.now
    sequence :guid do |n|
      "/my_unique_id#{n}"
    end
    author        'Inaki'
    visible        true
    state         'new'
  end
end
