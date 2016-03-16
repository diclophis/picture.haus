require 'spec_helper'

describe 'the welcome page' do
  it "should have a nice look" do
    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec.png")
  end

  it "should link to itself" do
    visit root_path
    page.should have_link "127.0.0.1"
  end

  it "should link to sign up" do
    visit root_path
    page.should have_link 'sign up', new_person_registration_path
  end

  it "should have awesome images" do
    person = valid_person
    person.save.should be_true
    database = Time.now.to_i

    count = 0
    Dir.glob(Rails.root.join("app/assets/images/image-*")).sort_by { rand }.each do |f|
      image = valid_image
      image.src = File.basename(f)
      image.save.should be_true
      finding = valid_finding
      finding.person = person
      finding.image = image
      finding.save.should be_true

      break if (count += 1) > 5
    end

    visit root_path
    page.save_screenshot("tmp/screenshots/welcome_spec_001.png", :full => true)
  end
end
