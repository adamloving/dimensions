require 'spec_helper'

describe Dimensions::Locator do
  describe "self.open_calais_tag" do
    before do
      category = mock
      category.stub(:name){"technology"}
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
      it "should return an array with all the tags" do
        tags = Dimensions::Tagger.open_calais_tag(@categories, @entities)
        tags.should =~ ['technology', 'twitter', 'facebook']
      end
    end
  end
end
