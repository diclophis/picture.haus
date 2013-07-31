require 'spec_helper'

describe ImageSeek do
  it "is a daemon" do
    ImageSeek.daemon {

      database = Time.now.to_i
      ImageSeek.create(database).should == database 

      image_one = valid_image
      image_one.src = "app/assets/images/banana.jpg"
      image_one.save.should be_true

      image_two = valid_image
      image_two.src = "app/assets/images/noise_alt.png"
      image_two.save.should be_true

      image_one_alt = valid_image
      image_one_alt.src = "app/assets/images/banana_alt.jpg"
      image_one_alt.save.should be_true

      last_left_id = nil
      last_right_id = nil

      3.times { |i|
        last_left_id = image_one.id + (3 * i)
        last_right_id = image_two.id + (3 * i)
        last_left_alt_id = image_one_alt.id + (3 * i)

        ImageSeek.add_image(database, last_left_id, image_one.src, is_url = false).should == 1
        ImageSeek.add_image(database, last_right_id, image_two.src, is_url = false).should == 1
        ImageSeek.add_image(database, last_left_alt_id, image_one_alt.src, is_url = false).should == 1

        ImageSeek.add_keyword_to_image(database, last_left_id, 0)
        ImageSeek.add_keyword_to_image(database, last_right_id, 0)
        ImageSeek.add_keyword_to_image(database, last_left_alt_id, 0)
      }

      similar_with_keywords_anded = ImageSeek.find_images_similar_with_keywords_to(database, last_left_id, 4, "0", 1)

      similar_with_keywords_anded.find { |image_id, rating|
        image_id == image_one.id && rating == 100.0
      }.should be_true

      similar_with_keywords_anded.find { |image_id, rating|
        image_id == image_one_alt.id && rating > 25.0
      }.should be_true

      similar_with_keywords_anded.find { |image_id, rating|
        image_id == image_two.id && rating > 0.0
      }.should_not be_true

      similar_with_keywords_ored = ImageSeek.find_images_similar_with_keywords_to(database, image_one.id, 4, "0", 0).should_not be_empty
      similar_without_keywords = ImageSeek.find_images_similar_to(database, image_one.id, 4).should_not be_empty
    }
  end
end