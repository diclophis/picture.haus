class WelcomeController < ApplicationController
  def index
    @recent_images = Image.paginate(
      :per_page => current_per_page,
      :page => current_page, 
      #:select => "images.*, count(*) as popularity, DATEDIFF(NOW(), findings.created_at) as newness",
      :select => "images.*, count(*) as popularity, MAX(findings.created_at) as newness",
      #:joins => "JOIN findings ON (findings.image_id = images.id AND DATEDIFF(NOW(), findings.created_at) < 1)",
      :joins => "JOIN findings ON (findings.image_id = images.id)",
      :group => "findings.image_id",
      :order => "newness DESC, popularity DESC, findings.created_at DESC"
    )
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
