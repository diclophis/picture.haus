require 'spec_helper'

describe 'the signup page' do
  it "should have a nice look" do
    visit new_person_registration_path
    page.save_screenshot("tmp/screenshots/signup_spec.png")
  end
end
