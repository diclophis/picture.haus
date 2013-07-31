class Similarity < ActiveRecord::Base
  belongs_to :image, :class_name => "Image"
  belongs_to :similar_image, :class_name => "Image"

  validates :image, :presence => true
  validates :similar_image, :presence => true
end
