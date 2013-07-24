require 'spec_helper'

describe 'the welcome page' do #, :js => true do #, :js => true do
  it "should have a nice look" do
    visit root_path
    page.save_screenshot("/tmp/file.png")
  end

  it "should link to itself" do
    visit root_path
    page.should have_link 'centerology', root_path
  end

  it "should link to risingcode.com" do
    visit root_path
    page.should have_link 'Land of the Rising Code', "http://risingcode.com"
  end
end
