require 'spec_helper'

describe NewsFeed do

  describe "location" do
    before do
      @news_feed = FactoryGirl.create(:news_feed)
    end

    context "when the news feed has no entities" do
      it 'should return nil' do
        @news_feed.location.should be_nil
      end
    end

    context "when the news feed has entities but none of type location" do
      it 'should return nil' do
        person = FactoryGirl.build(:entity, :name => "Inaki", :type => 'person')
        @news_feed.entities << person
        @news_feed.save
        @news_feed.location.should be_nil
      end
    end

    context "when the news feed has an entity of type location" do
      it 'should return the location' do
        location = FactoryGirl.build(:entity, :name => "GDL", :type => 'location')
        @news_feed.entities << location
        @news_feed.save
        @news_feed.location.should == location
      end
    end
  end

  describe "after save" do
    context "the news feed has no location and parameters for the location are sent" do
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
    context "the news feed already has a location and parameters for the location are sent" do
      it "should update the location entity for the news feed with that data" do
        news_feed = FactoryGirl.build(:news_feed)
        
        location = FactoryGirl.build(:entity, :name => "GDL", :type => 'location')
        news_feed.entities << location
        news_feed.save

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
