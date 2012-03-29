require 'spec_helper'


describe FeedEntry do
  #******************** SCOPES********************
  describe ".failed" do
    before do
      @entry1 = FactoryGirl.create(:feed_entry, :failed => false)
      @entry2 = FactoryGirl.create(:feed_entry, :failed => true)
    end

    it "should return only feed entries without errors when passed false" do
      results = FeedEntry.failed(false)
      results.should include(@entry1)
      results.should_not include(@entry2)
    end
    it "should return only feed entries with errors when passed true" do
      results = FeedEntry.failed(true)
      results.should include(@entry2)
      results.should_not include(@entry1)
    end
  end

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
      feed = mock_entries[0]
      feed.stub(:entries){mock_entries}
      Feedzirra::Feed.stub(:fetch_and_parse).with(url){feed}
      news_feed = mock(
        id: 1,
        url: url,
        name: 'news feed name')
      NewsFeed.stub(:find_by_url).with(url){news_feed}
      FeedEntry.stub(:save_feedzirra_response).with(news_feed.id, feed){true}
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
        @entry.stub(:fetched?){false}
        FeedEntry.localize(@entry).should be_false
      end
    end

    context "when the entry belongs to a localized newsfeed" do
      before do
        @feed_entry               = FactoryGirl.create(:feed_entry)
        @feed_entry.feed          = FactoryGirl.create(:news_feed, :name => "The Washington Post", :url => "http://thewashingtonpost.com")
        @feed_entry.feed.entities << FactoryGirl.create(:entity, :type => 'location', :serialized_data => {'longitude' => '1.0', 'latitude' => '2.0'})
        @feed_entry.feed.save
      end

      context "and the localization has not been successful" do
        before do
          @feed_entry.stub(:fetched?){true}
          @feed_entry.stub(:content){"some content"}

          calais_proxy = mock
          calais_proxy.stub(:doc_date){now}
          calais_proxy.stub_chain(:geographies){[]}
          Calais.stub(:process_document).with(:content => "some content", :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'] ){calais_proxy}
          @feed_entry.stub(:primary_location=).with(@feed_entry.feed.location){true}
        end

        it "should get the localization of the news feed" do
          lambda{
            FeedEntry.localize(@feed_entry).should be_true
          }.should change(Entity, :count).by(0)

          feed_entry = FeedEntry.find(@feed_entry.id)

          locations_map = feed_entry.entities.location.map do|location|
            coordinates = location.serialized_data
            [location.name, coordinates['longitude'], coordinates['latitude']]
          end
          
          location = @feed_entry.feed.location 
          locations_map.should include([location.name, location.serialized_data['longitude'], location.serialized_data['latitude']])
        end
      end
    end

    context 'successfully localizing the entry' do

      before do
        @entry               = FactoryGirl.create(:feed_entry, :published_at => nil)
        @entry.feed          = FactoryGirl.create(:news_feed, :name => "The Washington Post", :url => "http://thewashingtonpost.com")
        @entry.feed.entities << FactoryGirl.create(:entity, :type => 'location', :serialized_data => {'longitude' => '1.0', 'latitude' => '2.0'})
        @entry.feed.save
      end

      it "should return true and must save the new localization" do
        @entry.stub(:fetched?){true}
        @entry.stub(:content){"some content"}

        calais_proxy = mock

        now = Time.zone.now
        calais_proxy.stub(:doc_date){now}

        calais_proxy.stub_chain(:geographies){["dummy"]}

        location = FactoryGirl.build(:entity, :type => 'location', :name => "Seattle" )
        Dimensions::Locator.stub(:parse_locations).with(calais_proxy.geographies){[location]}
        @feed_entry.stub(:primary_location=).with(location){true}

        Calais.stub(:process_document).with(:content => "some content", :content_type => :raw, :license_id => APP_CONFIG['open_calais_api_key'] ){calais_proxy}

        lambda{
          FeedEntry.localize(@entry).should be_true
        }.should change(Entity, :count).by(1)

        entry = FeedEntry.find(@entry.id)


        entry.published_at.should_not be_nil
        
        entity = entry.entities.where(:name => "Seattle").first
        entity.should_not be_nil
        entity.feed_entries.find(entry.id).should_not be_nil
      end
    end
  end

  describe "#fetch content" do
    before do
      @entry = FactoryGirl.build(:feed_entry)
    end

    it "should return true if content is already there" do
      other_entry = FactoryGirl.create(:feed_entry)
      other_entry.content = "blah"
      other_entry.fetch_content!.should == "blah"
      EntryLocalizer.should have_queued(other_entry.id).in(:entries)
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
      FeedEntry.find(@entry.id).content.should == "Hola Mundo"
      EntryLocalizer.should have_queued(@entry.id).in(:entries)
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

  describe 'locations' do
    context "when the entry has no locations at all" do
      it 'should return an empty array' do
        @feed_entry = FactoryGirl.create(:feed_entry)
        @feed_entry.locations.should == []
      end
    end

    context "when the entry has locations" do
      it 'should return them' do
        @feed_entry   = FactoryGirl.create(:feed_entry)
        location_1    = FactoryGirl.build(:entity, :name => 'GDL', :type => 'location')
        location_2    = FactoryGirl.build(:entity, :name => 'Manzanillo', :type => 'location')
        person        = FactoryGirl.build(:entity, :name => 'Jaime', :type => 'person')
        @feed_entry.entities << location_1
        @feed_entry.entities << location_2
        @feed_entry.entities << person

        results = @feed_entry.locations
        results.should include(location_1)
        results.should include(location_2)
        results.should_not include(person)
      end
    end

  end

  describe 'primary_location' do

    context "when the entry has no locations at all" do
      it 'should return nil' do
        @feed_entry = FactoryGirl.create(:feed_entry)
        @feed_entry.primary_location.should  be_nil
      end
    end

    context "when the entry has locations" do
      it 'should return only the one marked as primary' do
        @feed_entry   = FactoryGirl.create(:feed_entry)
        location_1    = FactoryGirl.build(:entity, :name => 'GDL', :type => 'location')
        location_2    = FactoryGirl.build(:entity, :name => 'Manzanillo', :type => 'location')

        @feed_entry.entities << location_1
        @feed_entry.entities << location_2

        @feed_entry.primary_location = location_1

        @feed_entry.primary_location.should == location_1
      end

      it "should return the last location marked as primary" do
        @feed_entry   = FactoryGirl.create(:feed_entry)
        location_1    = FactoryGirl.build(:entity, :name => 'GDL', :type => 'location')
        location_2    = FactoryGirl.build(:entity, :name => 'Manzanillo', :type => 'location')

        @feed_entry.entities << location_1
        @feed_entry.entities << location_2

        @feed_entry.primary_location = location_1
        @feed_entry.primary_location = location_2



        @feed_entry.primary_location.should == location_2
        @feed_entry.secondary_locations.should == [location_1]

      end
    end

    
    it "should be independent for each entry and unique" do
      entry   = FactoryGirl.create(:feed_entry)
      entry2  = FactoryGirl.create(:feed_entry)

      locations = [ FactoryGirl.build(:entity, :name => 'GDL', :type => 'location'),
                    FactoryGirl.build(:entity, :name => 'Manzanillo', :type => 'location')]

      entry.entities  = locations
      entry2.entities = locations

      guadalajara = entry.locations.find_by_name('GDL')
      entry.primary_location = guadalajara

      manzanillo  = entry2.locations.find_by_name('Manzanillo')
      entry2.primary_location = manzanillo
      
      entry.primary_location.should  == guadalajara
      entry2.primary_location.should == manzanillo
    end
  end

  describe 'secondary_locations' do
    context "when the entry has no locations at all" do
      it 'should return empty array' do
        @feed_entry = FactoryGirl.create(:feed_entry)
        @feed_entry.secondary_locations.should  be_empty
      end
    end

    context "when the entry has locations" do
      it 'should return the array of the secondary locations' do
        @feed_entry   = FactoryGirl.create(:feed_entry)
        
        location_1    = FactoryGirl.build(:entity, :name => 'GDL', :type => 'location')
        location_2    = FactoryGirl.build(:entity, :name => 'Manzanillo')

        @feed_entry.entities << location_1
        @feed_entry.entities << location_2

        @feed_entry.primary_location = location_1
        @feed_entry.secondary_locations.should == [location_2]
      end
    end
  end

  describe "#tags" do

    it "should return the collection of tags twitter style and separated by spaces" do
      entry = FactoryGirl.create(:feed_entry)
      entry.entities << FactoryGirl.build(:entity, :type => 'tag', :tags => ["San Marino", "Colima", "san francisco", "Madrid", "Obama", "The Next Generation", "The NextGeneration"])
      entry.tags.should == '#SanMarino #Colima #SanFrancisco #Madrid #Obama #TheNextGeneration'
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

    describe 'after download' do
      before do
        ResqueSpec.reset!
      end

      it 'should enque the entry to be fetched' do
        @entry.download
        EntryContentFetcher.should have_queued(@entry.id).in(:entries)
      end
    end

    describe 'after localize' do
      before do
        ResqueSpec.reset!
      end

      it 'should enque the entry to be fetched' do
        @entry.update_attribute(:state, 'fetched')
        @entry.localize
        EntryTagger.should have_queued(@entry.id).in(:entries)
      end
    end

    describe 'after tagging' do
      before do
        ResqueSpec.reset!
      end

      it 'should enque the entry to be fetched' do
        @entry.update_attribute(:state, 'localized')
        @entry.tag
        EntryIndexer.should have_queued(@entry.id).in(:entries)
      end
    end
  end
end
