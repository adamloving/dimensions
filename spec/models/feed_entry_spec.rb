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
      @entry.fetch_content!.should == "Hola Mundo"
      @entry.content.should == "Hola Mundo"
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
      end
    end
  end

  # -------- State machine tests --------
  describe "change state" do
    before do
      @entry = FactoryGirl.build(:feed_entry)
    end
    
    it "should initialize with :loaded" do
      @entry.loaded?.should == true
    end
    
    it "should get valid states when :fetch, :localize, and :tag" do
      @entry.fetch
      @entry.fetched?.should == true
      @entry.localize
      @entry.localized?.should == true
      @entry.tag
      @entry.tagged?.should == true
    end
  end
end
