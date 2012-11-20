require 'spec_helper'

describe Admin::FeedEntriesController do

  shared_examples_for "an entry belonging to a feed" do
    it "should initialize the news feed" do
      subject
      assigns(:news_feed).should_not be_nil
    end
  end

  login_admin

  before do
    @news_feed = FactoryGirl.create(:news_feed)
    NewsFeed.stub(:find).with(@news_feed.id.to_s){@news_feed}
  end

  describe "GET 'index'" do
    describe "when receiving a news feed id" do
      before do
        @news_feed = mock_model(NewsFeed)
        NewsFeed.stub(:find).with('1'){@news_feed}
        @news_feed.stub_chain(:entries, :page, :per){[mock_model(FeedEntry)]}
      end

      it "should scope the feed entries to that news feed" do
        get "index", :news_feed_id => '1' 
        assigns(:feed_entries).should_not be_empty
      end
    end

    describe "when not receiving a news feed id" do
      before do
        FeedEntry.stub_chain(:page, :per){[mock_model(FeedEntry)]}
      end

      it "should get all the feed entries" do
        get "index"
        assigns(:feed_entries).should_not be_empty
      end
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

  describe "POST 'process_entry'" do

    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
    end



    describe "when the entry is in fetched state" do
      subject { post 'process_entry', news_feed_id: @news_feed.id, id: @entry.id, :current => "fetched"}

      context "succesul localization" do
        it "redirects to the the entry path and sets a notice" do
          FeedEntry.stub(:localize).with(@entry){true}
          Resque.should_receive(:enqueue).with(EntryLocalizer, @entry.id)
          subject
          response.should redirect_to admin_news_feed_feed_entry_path(@news_feed, @entry)
        end
      end
    end
  end

  describe "POST 'fetch_content'" do

    before do
      @entry = mock_model(FeedEntry)
      @news_feed.stub_chain(:entries, :find).with(@entry.id.to_s){@entry}
      @entry.stub(:fetch){true}
    end

    subject { post 'fetch_content', news_feed_id: @news_feed.id, id: @entry.id}

    describe "when then entry was saved" do
      it "redirects to the the entry path and sets a notice" do
        @entry.should_receive(:save){true}
        subject
        response.should redirect_to admin_news_feed_feed_entry_path(@news_feed, @entry)
        flash[:notice].should == "Entry successfully processed"
      end
    end

    describe "when the entry couldnt be saved" do
      it "redirects to the the entry path and sets error flash" do
        @entry.should_receive(:save){false}
        subject
        response.should redirect_to admin_news_feed_feed_entry_path(@news_feed, @entry)
        flash[:error].should == "There was an error saving the entry"
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
