require 'spec_helper'

describe ImageSeek do
  it "is a daemon" do
    ImageSeek.daemon {

      database = Time.now.to_i
      ImageSeek.create(database).should == database 

      image_one = valid_image
      image_one.src = "app/assets/images/noise.png"
      image_one.save.should be_true

      ImageSeek.add_image(database, image_one.id, image_one.src, is_url = false).should == 1
    }
  end
end
