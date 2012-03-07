require 'spec_helper'

describe Admin::NewsFeedsController do
  before do
    @news_feed = mock_model(NewsFeed)
  end

  describe "GET 'index'" do

    before do
      NewsFeed.stub(:all){[@news_feed]}
    end

    subject{ get "index" }


    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the feed entries" do
      subject
      assigns(:news_feeds).should_not be_empty
    end
  end

  describe "GET 'new'" do
    before do
      NewsFeed.stub(:new){@news_feed}
    end

    subject { get 'new' }

    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the feed entry" do
      subject
      assigns(:news_feed).should_not be_nil
    end
  end

  describe "GET 'create'" do
    before do
      NewsFeed.stub(:new).with('dummy' => true){@news_feed}
    end

    subject { get 'create', :news_feed => {:dummy => true} }


    it "should redirect to the index when entry is saved succesfully" do
      @news_feed.stub(:save){true}
      subject
      response.should redirect_to(admin_news_feeds_path)
    end

    it "should render the action new when entry is not saved" do
      @news_feed.stub(:save){false}
      subject
      response.should render_template(:new)
    end
  end

  describe "GET 'edit'" do
    before do
      NewsFeed.stub(:find).with(@news_feed.id.to_s){@news_feed}
    end


    subject{ get 'edit', id: @news_feed.id }


    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the entry" do
      subject
      assigns(:news_feed).should == @news_feed
    end
  end

  describe "GET 'update'" do
    before do
      NewsFeed.stub(:find).with(@news_feed.id.to_s){@news_feed}
    end

    subject { put 'update', id: @news_feed.id, :news_feed => {:dummy => true} }


    it "should redirect to the index when entry is saved succesfully" do
      @news_feed.stub(:update_attributes).with({"dummy" => true}){true}
      subject
      response.should redirect_to(admin_news_feeds_path)
    end

    it "should render the action new when entry is not saved" do
      @news_feed.stub(:update_attributes).with({"dummy" => true}){false}
      subject
      response.should render_template(:edit)
    end
  end

  describe "GET 'show'" do
    before do
      NewsFeed.stub(:find).with(@news_feed.id.to_s){@news_feed}
    end

    subject { get 'show', id: @news_feed.id}


    it "returns http success" do
      subject
      response.should be_success
    end

    it "assigns the entry" do
      subject
      assigns(:news_feed).should == @news_feed
    end
  end

  describe "GET 'destroy'" do
    #before do
      #@entry = mock_model(FeedEntry)
      #@news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    #end

    #subject { get 'destroy', news_feed_id: @news_feed.id, id: @entry.id }


    #it "returns http success" do
      #subject
      #response.should be_success
    #end
  end
end
