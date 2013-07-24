require 'spec_helper'

describe 'the welcome page' do #, :js => true do #, :js => true do
  it "should link to itself" do
    visit root_path
    #TODO: save screenshot artifacts somewhere
    page.save_screenshot('/tmp/file.png')
    page.should have_link 'centerology', root_path
  end
end
