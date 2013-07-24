require 'spec_helper'

describe 'the signup page' do
  it "should have a nice look" do
    visit new_person_registration_path
    page.save_screenshot("tmp/screenshots/signup_spec.png")
  end

  it "should link to root" do
    visit root_path
    page.should have_link "centerology", root_path
  end
end
