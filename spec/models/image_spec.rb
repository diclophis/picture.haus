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

    it "should require :src or :pending_upload" do
      @image.src = nil
      @image.pending_upload = nil
      @image.should_not be_valid
    end
  end

  describe "associations" do
    it "has latest finding" do
      @image.save.should be_true
      newer_finding = valid_finding
      newer_finding.image = @image
      newer_finding.save.should be_true
      @image.latest_finding.should == newer_finding
    end

    it "has similarities" do
      @image.save.should be_true
      @image.similarities.should be_empty
    end

    it "has similar images" do
      @image.save.should be_true
      similar_image = valid_image
      similar_image.save.should be_true
      similarity = valid_similarity
      similarity.image = @image
      similarity.similar_image = similar_image
      similarity.save.should be_true
      @image.similar_images.should include(similar_image)
    end

    it "has top similar images" do
      @image.save.should be_true
      similar_image1 = valid_image
      similar_image1.save.should be_true

      similar_image2 = valid_image
      similar_image2.save.should be_true

      similar_image3 = valid_image
      similar_image3.save.should be_true

      similarity = valid_similarity
      similarity.rating = 66
      similarity.image = @image
      similarity.similar_image = similar_image1
      similarity.save.should be_true

      similarity2 = valid_similarity
      similarity2.rating = 67 
      similarity2.image = @image
      similarity2.similar_image = similar_image2
      similarity2.save.should be_true

      similarity3 = valid_similarity
      similarity3.rating = 33
      similarity3.image = @image
      similarity3.similar_image = similar_image3
      similarity3.save.should be_true

      @image.similar_images[2].should == similar_image3
      @image.similar_images[1].should == similar_image1
      @image.similar_images[0].should == similar_image2
    end
  end
end
