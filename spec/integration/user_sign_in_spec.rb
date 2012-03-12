require "integration/acceptance_helper"

describe "admin user sign in" do
  it "allows admin users to sign in after they have registered" do

    user = AdminUser.create(:email    => "alindeman@example.com",
                            :password => "ilovegrapes")
    visit "/admin/news_feeds"
    page.current_path.should == "/admin/login"

    sign_in "alindeman@example.com", "ilovegrapes"

    within("span.current_user") do
      page.should have_content("alindeman@example.com")
    end
  end
end

