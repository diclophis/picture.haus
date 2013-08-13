require 'spec_helper'

describe FindingsController do
  describe "create" do
    it "should require an authenticated person" do
      post :create
      response.should_not be_success
    end

    it "should create an image and finding when given an image and finding" do
      @person = valid_person
      @person.save!
      sign_in @person

      lambda {
        lambda {
          post :create, {
            :finding => {
              :image => {
                :src => "http://any.uri",
                :title => "anything"
              },
              :tag_list => "tagged"
            }
          }
        }.should change(Finding, :count)
      }.should change(Image, :count)
    end
  end
end
