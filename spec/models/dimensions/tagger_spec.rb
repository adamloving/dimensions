require 'spec_helper'

describe Dimensions::Locator do
  describe "self.open_calais_tag" do
    let(:categories) { [double(:category, name: 'technology')] }

    it 'should return the first category name plus valid tags' do
      entities = [
        double(:tag1, attributes: { 'name' => 'twitter'}),
        double(:tag1, attributes: { 'name' => 'facebook'})
      ]
      tags = Dimensions::Tagger.open_calais_tag(categories, entities)
      tags.should =~ ['technology', 'twitter', 'facebook']
    end
    it 'should not accept tags with more thatn 30 chars' do
      entities = [
        double(:tag1, attributes: { 'name' => 't'*31}),
        double(:tag1, attributes: { 'name' => 'facebook'})
      ]
      tags = Dimensions::Tagger.open_calais_tag(categories, entities)
      tags.should =~ ['technology', 'facebook']
    end
    it 'should not accept tags with no name' do
      entities = [
        double(:tag1, attributes: {}),
        double(:tag1, attributes: { 'name' => 'facebook'})
      ]
      tags = Dimensions::Tagger.open_calais_tag(categories, entities)
      tags.should =~ ['technology', 'facebook']
    end
  end
end
