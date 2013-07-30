require 'spec_helper'

describe WelcomeController do
  describe "index resource" do
    it "should have an :index resource that renders a template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "feed resource" do
    it "should have an :feed resource that renders a template" do
      get :feed, :username => ""
      response.status.should == 404
    end
  end
end
