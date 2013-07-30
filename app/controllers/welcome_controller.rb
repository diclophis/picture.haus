class WelcomeController < ApplicationController
  def index
  end

  def feed
    @feeder = Person.find_by_username(params[:username])
    if @feeder
      @friendship = Friendship.new
      @friendship.person_id = @feeder.id
      @friendship.friend_id = current_person.to_param
    else
      flash[:alert] = "feed not found"
      render :action => :index, :status => :not_found
    end
  end
end
