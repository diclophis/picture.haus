require 'spec_helper'

describe Finding do
  before :each do
    @finding = valid_finding
    @finding.should be_valid
  end

  describe "validations" do
    it "should require :person" do
      @finding.person = nil
      @finding.should_not be_valid
    end

    it "should require :image" do
      @finding.image = nil
      @finding.should_not be_valid
    end
  end

  describe "tags" do
    it "has no tags to begin with" do
      @finding.tag_list.should be_empty
    end

    it "can have tags set" do
      lambda {
        @finding.tag_list = "wang, chung"
        @finding.save!
      }.should change(Tag, :count)
      
      Finding.find_tagged_with("wang").should include(@finding)
      Finding.find_tagged_with("chung").should include(@finding)
    end
  end
end
