
require 'spec_helper'

describe ActsAsTaggableOn::Tag do
  describe "#blacklist!" do
    it "should mark the tag as blacklisted" do
      tag = ActsAsTaggableOn::Tag.create(:name => 'not useful')
      tag.blacklist!
      tag.blacklisted?.should be_true
    end
  end
end
