require 'spec_helper'

describe 'the welcome page' do #, :js => true do #, :js => true do
  it "should have a nice look" do
    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec.png")
  end

  it "should link to itself" do
    visit root_path
    page.should have_link 'centerology', root_path
  end

  it "should link to risingcode.com" do
    visit root_path
    page.should have_link 'Land of the Rising Code', "http://risingcode.com"
  end

  it "should link to sign up" do
    visit root_path
    page.should have_link 'sign up', new_person_registration_path
  end

  it "should have awesome images" do
    person = valid_person
    person.save.should be_true
    database = Time.now.to_i

    ImageSeek.daemon {
      ImageSeek.create(database).should == database 
      Dir.glob(Rails.root.join("app/assets/images/*")).each do |f|
        image = valid_image
        image.src = "app/assets/images/" + File.basename(f)
        image.save.should be_true
        finding = valid_finding
        finding.person = person
        finding.image = image
        finding.save.should be_true

        ImageSeek.add_image(database, image.id, image.src, is_url = false).should == 1
        #similar_without_keywords = ImageSeek.find_images_similar_to(database, image_one.id, 4).should_not be_empty
      end
    }

    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec_001.png", :full => true)

  end
end
