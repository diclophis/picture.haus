class WelcomeController < ApplicationController
  def index
    @recent_images = 
    
    Image
    .all
    .joins("JOIN findings ON (findings.image_id = images.id)")
    .group("findings.image_id, images.id")
    .order("findings.created_at DESC")
    .paginate(
      :per_page => current_per_page,
      :page => current_page, 
    )
    #TODO: figure out better homepage SQL finders/scopes
    #.select("count(*) as popularity, MAX(findings.created_at) as newness")
    #.order("newness DESC, popularity DESC, newness DESC")
  end

  def feed
    @feeder = Person.find_by_username(params[:username])
    if @feeder
      @friendship = Friendship.new
      @friendship.person_id = @feeder.id
      @friendship.friend_id = current_person.to_param
      @images = @feeder.images.paginate(
        :per_page => current_per_page,
        :page => current_page, 
      )
    else
      flash[:alert] = "feed not found"
      render :action => :index, :status => :not_found
    end
  end
end
