require 'spec_helper'

describe NewsFeed do

  describe "after save" do
    context "when parameters for the location are sent" do
      it "should create a new location entity for the news feed with that data" do
        news_feed = FactoryGirl.build(:news_feed)
        news_feed.address             = 'Jilguero #75 Residencial Santa Barbara, Colima, Colima, Mexico'
        news_feed.location_latitude   = "3.4"
        news_feed.location_longitude  = "2.9"

        news_feed.save.should be_true
        news_feed.location.type.should                          == 'location'
        news_feed.location.name.should                          == 'Jilguero #75 Residencial Santa Barbara, Colima, Colima, Mexico'
        news_feed.location.serialized_data['latitude'].should   == "3.4"
        news_feed.location.serialized_data['longitude'].should  == "2.9"
      end
    end
  end

  describe "#load_entries" do
    before do
      @news_feed = FactoryGirl.build(:news_feed)
    end

    it 'should propagate the exception when the url is not valid' do
      Feedzirra::Feed.stub(:fetch_and_parse){nil}

      lambda {
        @news_feed.load_entries
      }.should raise_error('The feed is invalid')
    end

    it 'associate the entries with the feed' do
      entry = FactoryGirl.create(:feed_entry)

      FeedEntry.stub(:update_from_feed){[entry]}

      entry.should_receive(:download)

      @news_feed.load_entries

      entry.feed.should == @news_feed

      @news_feed.entries.should include(entry)
    end
  end
end
