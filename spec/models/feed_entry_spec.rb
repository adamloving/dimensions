require 'spec_helper'

describe FeedEntry do
  #******************** CLASS METHODS********************
  describe ".update_from_feed" do
    it 'should raise an exception when the feed is not valid' do
      Feedzirra::Feed.stub(:fetch_and_parse){nil}
      lambda {
        FeedEntry.update_from_feed('invalid url')
      }.should raise_error('The feed is invalid')
    end

    it 'should create entries whenever the feed --> feeds :p' do
      url = 'good url'

      mock_entries = [mock( title: "The first post",
             summary: 'I was so lazy to write my first post',
             url: '/some-url-x',
             published: Time.now,
             id: '/my-unique-id',
             author: 'Inaki',
             content: 'blah blah'),
      mock( title: "The second post",
             summary: 'I was so lazy but now I\'m not',
             url: '/some-other-url',
             published: Time.now,
             id: '/my-other-unique-id',
             author: 'Inaki',
             content: 'blah, blah, blah')]
      Feedzirra::Feed.stub(:fetch_and_parse).with(url){mock_entries}
      entries = nil
      lambda{
         entries = FeedEntry.update_from_feed(url)
      }.should change(FeedEntry, :count).by(2)

      entries.first.should be_an_instance_of(FeedEntry)
      entries.last.should be_an_instance_of(FeedEntry)
    end
  end
  describe "self.localize" do
    context "unfetched entry" do
      it "should return false" do
        @entry = mock_model(FeedEntry)
        FeedEntry.stub(:find).with(@entry.id){@entry}
        @entry.stub(:fetched?){false}
        FeedEntry.localize(@entry.id).should be_false
      end
    end
    context 'successfully localizing the entry' do
      it "should return true and must save the new localization" do
        @entry = FactoryGirl.create(:feed_entry)
        FeedEntry.stub(:find).with(@entry.id){@entry}
        @entry.stub(:fetched?){true} 
        @entry.stub(:content){"some content"}
        calais_proxy = mock
        calais_proxy.stub_chain(:geographies, :first, :attributes){
          {
            "shortname" => "Colima",
            "containedbycountry" => "Mexico",
            "latitude" => "123456",
            "longitude" => "654321"
          }
        }
        Calais.stub(:process_document).with(:content => "some content", :content_type => :raw, :license_id => "du295ff4zrg3rd4bwdk86xhy" ){calais_proxy}
        FeedEntry.localize(@entry.id).should be_true
        FeedEntry.find(@entry.id).tap do |entry|
          entry.shortname.should == "Colima"
          entry.country.should == "Mexico"
          entry.latitude.should == "123456"
          entry.longitude.should == "654321"
        end
      end
    end
  end

  describe "self.searchify_me" do
    context "unlocalized entry" do
      it "should return false" do
        @entry = FactoryGirl.create(:feed_entry)
        FeedEntry.stub(:find).with(@entry.id){@entry}
        @entry.stub(:localized?){false}
        FeedEntry.localize(@entry.id)should be_false
      end
    end
    context "succesfully tagging the entry" do
      it "should return true and must index the entry on searchify" do
        @entry = FactoryGirl.create(:feed_entry)
        FeedEntry.stub(:find).with(@entry.id){@entry}
        @entry.stub(:localized?){true}
        @entry.stub(:content){"this is the content of the entry"}
      end
    end
  end


  describe "#fetch content" do
    before do
      @entry = FactoryGirl.build(:feed_entry)
    end

    it "should return true if content is already there" do
      @entry.content = "blah"
      @entry.fetch_content!.should == "blah"
    end

    it "should fetch all the content existing between p tags in the requested url" do
      scraper = mock
      Scraper.stub(:define){ scraper }
      uri = mock
      URI.stub(:parse).with(@entry.url){uri}
      scraper.stub(:scrape).with(uri){
        ["Hola", "Mundo"]
      }
      @entry.should_receive(:fetch)
      @entry.fetch_content!.should == "Hola Mundo"
      @entry.content.should == "Hola Mundo"
      FeedEntry.find(@entry.id).content.should == "Hola Mundo"
    end

    context "failure to fetch content" do
      it "should rescue the exception and add this to serialized fetch errors" do
        scraper = mock
        Scraper.stub(:define){ scraper }
        uri = mock
        URI.stub(:parse).with(@entry.url){uri}
        scraper.should_receive(:scrape).with(uri).and_raise(Scraper::Reader::HTMLParseError)
        @entry.fetch_content!.should be_nil
        @entry.fetch_errors.should == {:error => "Scraper::Reader::HTMLParseError"}
        @entry.failed?.should be_true
        FeedEntry.find(@entry.id).failed?.should be_true
      end
    end
  end

  # -------- State machine tests --------
  describe "change state" do
    before do
      @entry = FactoryGirl.build(:feed_entry)
    end
    
    it "should initialize with :loaded" do
      @entry.new?.should == true
    end
    
    it "should get valid states when :fetch, :localize, and :tag" do
      @entry.download
      @entry.downloaded?.should be_true
      @entry.fetch
      @entry.fetched?.should == true
      @entry.localize
      @entry.localized?.should == true
      @entry.tag
      @entry.tagged?.should == true
    end
  end
end
