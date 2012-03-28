require "integration/acceptance_helper"

describe "news feeds integration" do

  it "has a way of creating a new news feed" do
    visit '/admin/news_feeds'

    user = AdminUser.create(:email    => "alindeman@example.com",
                            :password => "ilovegrapes")


    sign_in "alindeman@example.com", "ilovegrapes"   

    visit '/admin/news_feeds/new'

    fill_in 'news_feed_name', :with => 'King5'
    
    fill_in 'news_feed_url',  :with => 'http://king5.com'

    fill_in 'news_feed_address', :with => 'Jilguero #75 Colima Col'

    page.find('#news_feed_location_longitude').set('1')

    page.find('#news_feed_location_latitude').set('2')
    
    click_on 'Create'

    news_feed = NewsFeed.find_by_name('King5')
    news_feed.should_not be_blank

    coordinates = news_feed.location.serialized_data
    coordinates['latitude'].should == '2'
    coordinates['longitude'].should == '1'
  end
end

