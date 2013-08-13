class FindingsController < ApplicationController
  before_filter :authenticate_person!

  def create
    @finding = Finding.new(finding_params)
    @image = Image.where(:src => image_params[:image][:src]).first || Image.new(image_params[:image])
    @finding.image = @image
    @finding.person = current_person
    p @image
    p @finding
    if @finding.save
      redirect_to image_path(@image.id)
    else
      render :new
    end
  end

  def index
    redirect_to :new
  end

  def new
    @finding = Finding.new
    @image = Image.new
  end

private

  def finding_params
    params.require(:finding).permit(:tag_list)
  end

  def image_params
    params.require(:finding).permit(:image => [:src, :title])
  end
end