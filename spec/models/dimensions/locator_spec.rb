require 'spec_helper'

describe Dimensions::Locator do
  describe "<open_calais_location>" do
    context "when only one location has been found" do
      before do
        @geographies = mock
        @geography = mock
        @geographies.stub(:count) {1}
        @geographies.stub(:first){@geography}
        @geography.stub(:name){"Afghanistan"}
        @geography.stub(:attributes).and_return({"docId"=> "x", "latitude"=>"33.9791287582", "longitude"=>"66.4849387488", "containedbycountry" => "Afghanistan"})
      end

      it "should return this location as a location entity" do
        location = Dimensions::Locator.open_calais_location(@geographies)
        location.name.should == "Afghanistan"
        location.type.should == "location"
        location.serialized_data.tap do|data|
          data["docId"].should be_nil
          data["latitude"].should == "33.9791287582"
          data["longitude"].should == "66.4849387488"
          data["containedbycountry"].should == "Afghanistan"
        end
      end
    end
  end
end
