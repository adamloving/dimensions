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
             url: '/some-url',
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
end
