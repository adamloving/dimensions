FactoryGirl.define do
  factory :feed_entry do
    name          "The first post"
    summary       'I was so lazy to write my first post' 
    url           '/some-url'
    published_at  Time.now
    sequence :guid do |n|
      "/my_unique_id#{n}"
    end
    author        'Inaki'
    visible        true
  end
end
