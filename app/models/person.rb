class Person < ActiveRecord::Base
  validates :username, :presence => true
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # before_save :ensure_authentication_token

  has_many_friends
  has_many :findings
  has_many :images, :through => :findings

  before_destroy { |record|
    record.findings.destroy_all
  }
end
