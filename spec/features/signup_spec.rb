require 'spec_helper'

describe 'the signup page' do
  it "should have a nice look" do
    visit new_person_registration_path
    page.save_screenshot("tmp/screenshots/signup_spec.png")
  end

  it "should link to root" do
    visit root_path
    page.should have_link "root", root_path
  end

  it "should remember username and email but not password on submit" do
    visit new_person_registration_path

    fill_in 'Username', :with => "wangchung"
    fill_in 'Password', :with => "tonite"
    fill_in 'Email', :with => "every@body"

    click_on 'sign up'

    find_field('Username').value.should == "wangchung"
    find_field('Email').value.should == "every@body"
    find_field('Password').value.should == ""

    page.save_screenshot("tmp/screenshots/signup_spec_001.png")
  end
end
