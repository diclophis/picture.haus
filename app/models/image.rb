require 'rubygems'
require 'fog'

class Image < ActiveRecord::Base
  attr_accessor :pending_upload

  has_many :findings, -> { order :created_at }
  has_one :latest_finding, -> { order :created_at }, :class_name => 'Finding'

  validates_presence_of :title
  validates_presence_of :src

  has_one :latest_finding, -> { order :created_at}, :class_name => 'Finding'
  has_many :similarities, -> { order('rating ASC').uniq }
  has_many :similar_images, -> { select('images.*', 'similarities.rating').order('rating DESC').uniq.limit(3) }, :through => :similarities

  before_validation :src_is_fetchable

  before_destroy { |record|
    raise
  }

  def src_is_fetchable
    body = nil

    if src.present?
      begin
        url = URI.parse(src)
        unless url.is_a?(URI::Generic)
          res = Net::HTTP.get_response(url)
          errors.add(:src, ["fetch", res.code, res.message].join(",")) unless res.code == "200"
          if res['Content-Type'].strip.present?
            errors.add(:src, "not an image") unless res['Content-Type'].include?("image")
          end
        end
      rescue EOFError => e
        errors.add(:src, e.message)
      rescue SocketError => e
        errors.add(:src, e.message)
      rescue URI::InvalidURIError => e
        errors.add(:src, e.message)
      end
    end

    unless body
      if pending_upload && pending_upload.size > 0
        self.src = pending_upload.original_filename
        #body = pending_upload
        body = open(pending_upload.path, 'rb', :encoding => 'BINARY')
      else
        size = nil
        body = nil
        errors.add(:src, "size")
      end
    end

    if body
      # create a connection
      connection = Fog::Storage.new({
        :provider                 => 'AWS',
        :aws_access_key_id        => ENV["AWS_ACCESS_KEY_ID"],
        :aws_secret_access_key    => ENV["AWS_SECRET_KEY"],
        :region                   => "us-west-1"
      })

      #puts ENV.inspect

      ## First, a place to contain the glorious details
      #directory = connection.directories.create(
      #  :key    => "fog-demo-#{Time.now.to_i}", # globally unique name
      #  :public => true
      #)
      directory = connection.directories.get(bucket) || connection.directories.create(:key => bucket, :public => true)

      # list directories
      # puts connection.directories

      # upload that resume
      key = Digest::MD5.hexdigest(src)

      file = directory.files.get(key)
      file = directory.files.new(:key => key) unless file
      file.body = body
      file.acl = 'public-read'
      raise unless file.save

      connection = nil
    end
  end

  def public_url
    "https://#{bucket}.s3.amazonaws.com/" + Digest::MD5.hexdigest(src)
  end

  def bucket
    ENV["AWS_S3_BUCKET"]
  end
end
