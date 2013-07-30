class WelcomeController < ApplicationController
  def index
  end
  def feed
    @feeder = Person.find_by_username(params[:username])
    @friendship = Friendship.new
    @friendship.person_id = @feeder.id
    @friendship.friend_id = current_person.id
  end
end
