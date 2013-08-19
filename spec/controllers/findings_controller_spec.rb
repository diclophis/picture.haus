require 'spec_helper'

describe FindingsController do
  describe "create" do
    it "should require an authenticated person" do
      post :create
      response.should_not be_success
    end

    describe "should create an image and finding when given an image and finding" do
      before :each do
        @person = valid_person
        @person.save!
        @params = {
          :finding => {
            :image => {
              :src => "http://any.uri",
              :title => "anything"
            },
            :tag_list => "tagged"
          }
        }
      end

      it "should work with login" do
        sign_in @person
      end

      it "should work with authentication_tokens" do
        @params[:authentication_token] =  @person.authentication_token
      end

      after :each do
        lambda {
          lambda {
            post :create, @params
          }.should change(Finding, :count)
        }.should change(Image, :count)
      end
    end
  end
end
