require 'spec_helper'

describe 'the welcome page' do #, :js => true do #, :js => true do
  it "should have a nice look" do
    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec.png")
  end

  it "should link to itself" do
    visit root_path
    page.should have_link "root", root_path
  end

  it "should link to sign up" do
    visit root_path
    page.should have_link 'sign up', new_person_registration_path
  end

  it "should have awesome images" do
    pending

    person = valid_person
    person.save.should be_true
    database = Time.now.to_i

    ImageSeek.daemon {
      ImageSeek.create(database).should == database 
      count = 0
      Dir.glob(Rails.root.join("app/assets/images/image-*")).sort_by { rand }.each do |f|
        image = valid_image
        image.src = File.basename(f)
        image.save.should be_true
        finding = valid_finding
        finding.person = person
        finding.image = image
        finding.save.should be_true

        ImageSeek.add_image(database, image.id, "app/assets/images/" + image.src, is_url = false).should == 1
        break if (count += 1) > 5
      end

      Image.all.each { |image|
        similar_without_tags = ImageSeek.find_images_similar_to(database, image.id, 4).collect { |image_id, rating|
          unless image.id == image_id then
            similar_image = Image.find(image_id)
            #similar_image.rating = rating
            [similar_image, rating, "without"]
          end
        }
        (similar_without_tags).compact.each { |similar_image, rating, join_type|
          similarity = Similarity.new
          similarity.image_id = image.id
          similarity.similar_image_id = similar_image.id
          similarity.rating = rating
          similarity.join_type = join_type
          similarity.save.should be_true
        }
      }
    }

    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec_001.png", :full => true)

  end
end
