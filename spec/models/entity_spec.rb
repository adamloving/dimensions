require 'spec_helper'

describe Entity do
  describe "self.location" do
    it "should get only entities with the type location" do
      @location = FactoryGirl.create(:entity, :type => "location" )
      @person = FactoryGirl.create(:entity, :type => "person")

      results = Entity.location
      results.should include(@location)
      results.should_not include(@person)
    end
  end

  describe "name" do
    it "should be unique" do
      entity    = FactoryGirl.create(:entity, :name => 'Seattle, Washington', :type => 'location')
      repeated  = FactoryGirl.build(:entity, :name => 'Seattle, Washington', :type => 'location')
      repeated.should_not be_valid
    end
  end

  describe "clear tag" do
  
    before do
      @tag = Entity.create(:name => 'the tag', :tags => ['twitter', 'facebook', 'linkedin'], :type => 'tag')
    end

    it "should clear the specified tag from the list of tags" do
      @tag.clear_tag('twitter')
      @tag.save
      tag = Entity.find(@tag.id)
      tag.tags.should =~ ['facebook', 'linkedin']
    end
  end
end
