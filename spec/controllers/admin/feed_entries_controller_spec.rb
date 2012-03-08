require 'spec_helper'

describe Admin::FeedEntriesController do

  shared_examples_for "an entry belonging to a feed" do
    it "should initialize the news feed" do
      subject
      assigns(:news_feed).should_not be_nil
    end
  end

  before do
    @news_feed = FactoryGirl.create(:news_feed)
    NewsFeed.stub(:find).with(@news_feed.id.to_s){@news_feed}
  end

  describe "GET 'index'" do

    before do
      @news_feed.stub(:entries){[FactoryGirl.build(:feed_entry)]}
    end

    subject{ get "index", :news_feed_id => @news_feed.id.to_s }

    it_should_behave_like  "an entry belonging to a feed"

    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the feed entries" do
      subject
      assigns(:feed_entries).should_not be_empty
    end
  end

  describe "GET 'new'" do
    subject { get 'new', news_feed_id: @news_feed.id.to_s}

    it_should_behave_like  "an entry belonging to a feed"

    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the feed entry" do
      subject
      assigns(:feed_entry).should_not be_nil
    end
  end

  describe "GET 'create'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :build).with({:dummy => true}.stringify_keys){@entry}
    end

    subject { get 'create', news_feed_id: @news_feed.id, :feed_entry => {:dummy => true} }


    it "should redirect to the index when entry is saved succesfully" do
      @entry.stub(:save){true}
      subject
      response.should redirect_to(admin_news_feed_feed_entries_path(@news_feed))
    end

    it "should render the action new when entry is not saved" do
      @entry.stub(:save){false}
      subject
      response.should render_template(:new)
    end
  end

  describe "GET 'edit'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end


    subject{ get 'edit', news_feed_id: @news_feed.id.to_s.to_s, id: @entry.id }

    it_should_behave_like  "an entry belonging to a feed"

    it "returns http success" do
      subject
      response.should be_success
    end

    it "should assign the entry" do
      subject
      assigns(:feed_entry).should == @entry
    end
  end

  describe "GET 'update'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end

    subject { put 'update', news_feed_id: @news_feed.id, :id => @entry.id, :feed_entry => {:dummy => true} }


    it "should redirect to the index when entry is saved succesfully" do
      @entry.stub(:update_attributes).with({"dummy" => true}){true}
      subject
      response.should redirect_to(admin_news_feed_feed_entries_path(@news_feed))
    end

    it "should render the action new when entry is not saved" do
      @entry.stub(:update_attributes).with({"dummy" => true}){false}
      subject
      response.should render_template(:edit)
    end
  end

  describe "GET 'show'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end

    subject { get 'show', news_feed_id: @news_feed.id, id: @entry.id}

    it_should_behave_like  "an entry belonging to a feed"

    it "returns http success" do
      subject
      response.should be_success
    end

    it "assigns the entry" do
      subject
      assigns(:feed_entry).should == @entry
    end
  end

  describe "PUT 'toggle_visible'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end

    subject { put 'toggle_visible', news_feed_id: @news_feed.id, id: @entry.id}

    it "returns http success" do
      @entry.stub(:toggle).with(:visible){@entry}
      @entry.should_receive(:save){true}
      subject
      response.should redirect_to admin_news_feed_feed_entry_path(@news_feed, @entry)
    end
  end 

  describe "POST 'fetch_content'" do

    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end

    subject { post 'fetch_content', news_feed_id: @news_feed.id, id: @entry.id, :format => :xhr}

    describe "when there were no fetch errors" do
      it "redirects to the the entry path and sets a notice" do
        @entry.stub(:fetch_content!){"some content"}
        @entry.stub(:fetch_errors){nil}
        @entry.should_receive(:save)
        @entry.stub(:content){"some content"}
        expected = { 
          :message  => "we successfully processed your entry",
          :content    => "some content"
        }.to_json

        subject
        response.should be_success
        response.body.should == expected
      end
    end

    describe "when there are fetch errors" do
      it "redirects to the the entry path and sets error flash" do
        @entry.stub(:fetch_content!){nil}
        @entry.stub(:fetch_errors){{:error => "Blah"}}
        expected = { 
          :message  => "we couldn't process your entry",
          :error => ["Blah"]
        }.to_json
        subject
        response.should be_success
        response.body.should == expected
      end
    end
  end 

  describe "GET 'destroy'" do
    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end

    subject { get 'destroy', news_feed_id: @news_feed.id, id: @entry.id }
  end
end
