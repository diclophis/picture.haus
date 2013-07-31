require 'spec_helper'

describe Similarity do
  describe "validations" do
    before :each do
      @similarity = valid_similarity
      @similarity.should be_valid
    end

    it "should have a image" do
      pending
    end
  end
end
