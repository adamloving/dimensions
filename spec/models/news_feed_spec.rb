require 'spec_helper'
require 'ruby-debug'

describe FeedEntry do
  describe "#load_entries" do
    before do
      @news_feed = Factory.build(:news_feed)
    end

    it 'should propagate the exception when the url is not valid' do
      Feedzirra::Feed.stub(:fetch_and_parse){nil}

      lambda {
        @news_feed.load_entries
      }.should raise_error('The feed is invalid')
    end

    it 'associate the entries with the feed' do
      entry = Factory.create(:feed_entry)

      FeedEntry.stub(:update_from_feed){[entry]}

      @news_feed.load_entries

      entry.feed.should == @news_feed

      @news_feed.entries.should include(entry)
    end
  end
end
