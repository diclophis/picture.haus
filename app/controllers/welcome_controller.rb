class WelcomeController < ApplicationController
  def index
  end
  def feed
    @feeder = Person.find_by_username(params[:username])
    raise @feeder
  end
end
