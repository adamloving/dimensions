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
end
