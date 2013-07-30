require 'spec_helper'

describe Image do
  before :each do
    @image = valid_image
    @image.should be_valid
  end

  describe "validations" do
    it "should require :title" do
      @image.title = nil
      @image.should_not be_valid
    end

    it "should require :src" do
      @image.src = nil
      @image.should_not be_valid
    end
  end
end
