require 'spec_helper'

describe 'the signin page' do
  it "should have a nice look" do
    visit new_person_session_path
    page.save_screenshot("tmp/screenshots/signin_spec.png")
  end

  it "should link to root" do
    visit root_path
    page.should have_link root_path
  end
end
