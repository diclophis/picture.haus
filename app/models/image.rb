class Image < ActiveRecord::Base
  has_many :findings, -> { order :created_at }
  has_one :latest_finding, -> { order :created_at }, :class_name => 'Finding'

  validates_presence_of :title
  validates_presence_of :src

  has_one :latest_finding, -> { order :created_at}, :class_name => 'Finding'
  has_many :similarities, -> { order('rating ASC').uniq }
  has_many :similar_images, -> { order('rating DESC').limit(3).uniq }, :through => :similarities
end
