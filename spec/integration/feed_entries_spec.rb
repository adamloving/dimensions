require "integration/acceptance_helper"

describe "feed entries" do

  it "has an index page" do
    visit '/admin/login'

    user = AdminUser.create(:email    => "alindeman@example.com",
                            :password => "ilovegrapes")
  
    news_feed = FactoryGirl.create(:news_feed)

    feed_entry = FactoryGirl.create(:feed_entry, :feed => news_feed)

    sign_in "alindeman@example.com", "ilovegrapes"

    visit admin_news_feed_feed_entries_path(news_feed)

    within('table.feed_entries') do
      page.should have_content(feed_entry.name)
    end 
  end

  describe "show page" do
    before do
      visit '/admin/login'

      user = AdminUser.create(:email    => "alindeman@example.com",
                              :password => "ilovegrapes")

      @news_feed = FactoryGirl.create(:news_feed)

      @feed_entry = FactoryGirl.create(:feed_entry, :feed => @news_feed)

      sign_in "alindeman@example.com", "ilovegrapes"
    end

    it 'offers the user the ability to remove tags from the entry' do
      @feed_entry.entities << FactoryGirl.create(:entity, :type => 'tag', :tags => ['Hello', 'World'])
      @feed_entry.update_attribute(:state, 'tagged')
      @feed_entry.save
      
      visit admin_news_feed_feed_entry_path(@news_feed, @feed_entry)

      within('table.feed_entry') do
        page.should have_css('td span em', :text => 'Hello')
        page.should have_css('td span em', :text => 'World')
      end

      #TODO Mozilla is breaking the js tests. We need to use capybara-webkit but unfortunately it takes a long of time to setup. I'll be doing that soon.
    end
  end
end

