class Image < ActiveRecord::Base
  has_many :findings, -> { order :created_at }
  has_one :latest_finding, -> { order :created_at }, :class_name => 'Finding'

  validates_presence_of :title
  validates_presence_of :src

  has_one :latest_finding, -> { order :created_at}, :class_name => 'Finding'
  has_many :similarities, -> { order 'rating ASC' } #uniq/distinct cannot visit
  has_many :similar_images, :through => :similarities, :limit => 3, :order => 'rating DESC', :uniq => true
  #has_many :top_similar_images, :source => :similar_image, :through => :similarities, :limit => 3, :order => 'rating ASC', :uniq => true
end
