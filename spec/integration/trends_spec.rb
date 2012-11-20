require "integration/acceptance_helper"

describe "trends admin" do

  before do
    visit '/admin'
    user = AdminUser.create(:email    => "alindeman@example.com",
                            :password => "ilovegrapes")
    sign_in "alindeman@example.com", "ilovegrapes"
  end

  it "showing the list of the 20 most popular trends, without blacklisted trends" do
    fe = FactoryGirl.create(:feed_entry)
    fe.tag_list = ['red', 'green', 'blue']
    fe.save

    click_on 'Trends'

    page.current_path.should ==  admin_trends_path
  
    within('table.trends') do
      page.should have_css('td.trend', :text => 'red')
      page.should have_css('td.trend', :text => 'green')
      page.should have_css('td.trend', :text => 'blue')
    end
  end

  it 'blacklisting trends' do
    fe = FactoryGirl.create(:feed_entry)
    fe.tag_list = ['red', 'green', 'blue', 'unimportant_trend']
    fe.save

    tag = fe.tags.find_by_name('unimportant_trend')

    visit admin_trends_path

    click_on "blacklist_trend_#{tag.id}"

    page.current_path.should == admin_trends_path

    within('table.trends') do
      page.should have_css('td.trend', :text => 'red')
      page.should have_css('td.trend', :text => 'green')
      page.should have_css('td.trend', :text => 'blue')
      page.should_not have_css('td.trend', :text => 'unimportant_trend')
    end
  end
end

