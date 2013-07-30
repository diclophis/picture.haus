require 'spec_helper'

describe 'the edit_person_registration page' do
  it "looks nice" do
    @person = valid_person
    @person.should be_valid
    @person.save!

    finding = Finding.new
    finding.person = @person
    finding.image = Image.new
    finding.image.title = "foo"
    finding.image.src = "/assets/noise.png" #("http://localhost:#{Capybara.server_port}/assets/noise.png")
    finding.save!

    visit feed_path(@person.username)
    page.save_screenshot("tmp/screenshots/feed_spec.png")
  end
end
