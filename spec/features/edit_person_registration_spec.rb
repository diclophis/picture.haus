require 'spec_helper'

describe 'the edit_person_registration page' do

  describe 'when logged in' do
    before :each do
      @person = valid_person
      @person.should be_valid

      visit new_person_registration_path
      fill_in 'Username', :with => @person.username
      fill_in 'Email', :with => @person.email
      fill_in 'Password', :with => @person.password 
      fill_in 'Password confirmation', :with => @person.password 

      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_wtf_2.png")

      click_on 'sign up'

      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_wtf.png")
    end

    it 'should allow attributes to be edited' do
      visit edit_person_registration_path
      page.save_screenshot("tmp/screenshots/edit_person_registration_spec.png")

      find_field('Username').value.should == @person.username

      fill_in 'Username', :with => @person.username + "_edited"
      fill_in 'Current password', :with => @person.password

      find_field('Username').value.should == @person.username + "_edited"
      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_004.png")

      click_on 'update'
      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_002.png")

      visit edit_person_registration_path
      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_003.png")

      find_field('Username').value.should == @person.username + "_edited"
    end
  end

  describe 'when not logged in' do
    it "should have a nice redirect" do
      visit edit_person_registration_path
      page.save_screenshot("tmp/screenshots/edit_person_registration_spec_001.png")
    end
  end
end
