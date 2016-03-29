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
    image_added = ImageSeek.add_image(self.image.id, self.image.public_url, self.tag_list, is_url = true)
    link_similar(self.image.id, self.tag_list)
  end

  #TODO: make this not be recursive, and actually use tag-based weighting/nested search
  def link_similar(root_image_id, tag_list = [], depth = 0, max_depth = 1)
    similar_without_keywords = ImageSeek.find_images_similar_to(root_image_id, tag_list, 10)
    similar_without_keywords.each do |image_id, rating|
      unless image_id.to_i == root_image_id.to_i
        if rating.to_f < 90.0 && is_still_found = Finding.find_by_image_id(image_id)
          begin
            Similarity.find_or_create_by({:image_id => root_image_id, :similar_image_id => image_id, :join_type => ""}) { |similarity|
              similarity.rating = rating
            }.save!
          rescue ActiveRecord::RecordNotUnique
            retry
          end

          if (depth < max_depth) 
            link_similar(image_id, tag_list, depth + 1, max_depth)
          end
        end
      end
    end
  end
end
