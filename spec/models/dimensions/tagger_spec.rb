require 'spec_helper'

describe Dimensions::Locator do
  describe "self.open_calais_tag" do
    before do
      category = mock
      category.stub_chain(:name){"technology"}
      @categories = [category]
      entity1 = mock
      entity1.stub(:attributes){
        {"name" => "twitter"}
      }
      entity2 = mock
      entity2.stub(:attributes){
        {"name" => "facebook"}
      }
      @entities = [entity1, entity2]
    end

    context "this is the first time the entry has been tagged and the tags are valid" do
      it "should create a new entity with the tags for the entry" do
        tag = Dimensions::Tagger.open_calais_tag(@categories, @entities, "my name")
        tag.name.should == "my name"
        tag.tags.should =~ ['technology', 'twitter', 'facebook']
        tag.type.should == 'tag'
        tag.should be_new_record
      end
    end
    context "this is the second time the entry has been tagged and the tags are valid" do
      before do
        Entity.create(:name => 'my name', :tags => ['delete', 'me'], :type => 'tag')
      end

      it "should update the tags for the entry" do
        tag = Dimensions::Tagger.open_calais_tag(@categories, @entities, "my name")
        tag.name.should == "my name"
        tag.tags.should =~ ['technology', 'twitter', 'facebook']
        tag.type.should == 'tag'
        tag.should be_valid
        tag.should_not be_new_record
      end
    end
  end
end
