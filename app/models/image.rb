class Image < ActiveRecord::Base
  has_many :findings, -> { order :created_at }
  has_one :latest_finding, -> { order :created_at }, :class_name => 'Finding'

  validates_presence_of :title
  validates_presence_of :src

  has_one :latest_finding, -> { order :created_at}, :class_name => 'Finding'
  has_many :similarities, -> { order('rating ASC').uniq }
  has_many :similar_images, -> { order('rating DESC').uniq.limit(3) }, :through => :similarities

  validate :src_is_fetchable

  def src_is_fetchable
    if src.present? && Rails.env != "test"
      begin
        url = URI.parse(src)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)
        errors.add(:src, [res.code, res.message].join(",")) unless res.code == "200"
        if res['Content-Type'].strip.present?
          errors.add(:src, "not an image") unless res['Content-Type'].include?("image")
        end
      rescue ArgumentError => e
        errors.add(:src, e.message)
      rescue SocketError => e
        errors.add(:src, e.message)
      rescue URI::InvalidURIError => e
        errors.add(:src, e.message)
      end
    end
  end
end
