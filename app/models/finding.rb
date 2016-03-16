class Finding < ActiveRecord::Base
  acts_as_taggable
  belongs_to :person
  belongs_to :image, :autosave => true
  validates_presence_of :person
  validates_associated :person
  validates_presence_of :image
  validates_associated :image

  after_save :add_image_to_image_seek

  before_destroy { |record|
    record.image.similarities.destroy_all
  }

  private

  def add_image_to_image_seek
    image_added = ImageSeek.add_image(self.image.id, self.image.public_url, is_url = true)
    link_similar(self.image.id)
  end

  #TODO: make this not be recursive, and actually use tag-based weighting/nested search
  def link_similar(root_image_id, depth = 0, max_depth = 1)
    similar_without_keywords = ImageSeek.find_images_similar_to(root_image_id, 10)
    similar_without_keywords.each do |image_id, rating|
      unless image_id.to_i == root_image_id.to_i
        if rating.to_f < 90.0 && is_still_found = Finding.find_by_image_id(image_id)
          similarity = Similarity.new({:image_id => root_image_id, :similar_image_id => image_id, :rating => rating, :join_type => ""})
          similarity.save
          if (depth < max_depth) 
            link_similar(image_id, depth + 1, max_depth)
          end
        end
      end
    end
  end
end
