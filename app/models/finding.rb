class Finding < ActiveRecord::Base
  acts_as_taggable
  belongs_to :person
  belongs_to :image
  validates_presence_of :person
  validates_associated :person
  validates_presence_of :image
  validates_associated :image

  after_save :add_image_to_image_seek

  def add_image_to_image_seek
    image_added = ImageSeek.add_image($imageseek_database, self.image.id, self.image.src, is_url = true)
    p image_added

    #similar_with_keywords_anded = ImageSeek.find_images_similar_with_keywords_to($imageseek_database, self.image.id, 4, "0", 1)
    #similar_with_keywords_anded.find { |image_id, rating|
    #  image_id == image_one.id && rating > 80.0
    #}.should be_true
    #similar_with_keywords_ored = ImageSeek.find_images_similar_with_keywords_to($imageseek_database, self.image.id, 4, "0", 0)
    #.should_not be_empty
    #(database_id, image_id, count = 10, keywords = "", join = 0)

    # (database_id, image_id, count = 10)
    similar_without_keywords = ImageSeek.find_images_similar_to($imageseek_database, self.image.id, 4)

    similar_without_keywords.each do |image_id, rating|
      similarity = Similarity.new({:image_id => self.image.id, :similar_image_id => image_id, :rating => rating, :join_type => ""})
      similarity.save!
    end

    ImageSeek.save_databases
  end
end
