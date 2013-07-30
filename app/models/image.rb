class Image < ActiveRecord::Base
  has_many :findings, :order => :created_at
  has_one :latest_finding, :class_name => 'Finding', :order => :created_at

  validates_presence_of :title
  validates_presence_of :src
end
