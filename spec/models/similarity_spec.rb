require 'spec_helper'

describe Similarity do
  describe "validations" do
    before :each do
      @similarity = valid_similarity
      @similarity.should be_valid
    end

    it "should have a image" do
      @similarity.image = nil
      @similarity.should_not be_valid
    end

    it "should have a similar mage" do
      @similarity.similar_image = nil
      @similarity.should_not be_valid
    end
  end
end
