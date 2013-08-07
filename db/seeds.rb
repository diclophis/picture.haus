# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def valid_person
  @_valid_person_id ||= 0
  @_valid_person_id += 1
  person = Person.new
  person.username = "foo"
  person.email = "foo-#{@_valid_person_id}@foo.com"
  person.password = "qwerty123"
  person
end

def valid_friendship
  person = valid_person
  person.save!
  friend = valid_person
  friend.save!
  friendship = Friendship.new
  friendship.friendshipped_for_me = friend
  friendship.friendshipped_by_me = person
  friendship
end

def valid_image #(router = Router.new)
  image = Image.new
  image.title = "title"
  image
end

def valid_finding
  finding = Finding.new
  finding.person = valid_person
  finding.image = valid_image
  finding
end

def valid_similarity
  similarity = Similarity.new
  similarity.image = valid_image
  similarity.similar_image = valid_image
  similarity.rating = 0
  similarity.join_type = ""
  similarity
end

person = valid_person
person.save
database = Time.now.to_i

ImageSeek.daemon {
  ImageSeek.create(database)
  Dir.glob(Rails.root.join("app/assets/images/*")).each do |f|
    image = valid_image
    image.src = File.basename(f)
    image.save
    finding = valid_finding
    finding.person = person
    finding.image = image
    finding.save
    ImageSeek.add_image(database, image.id, f, is_url = false)
  end

  Image.all.each { |image|
    similar_without_tags = ImageSeek.find_images_similar_to(database, image.id, 4).collect { |image_id, rating|
      unless image.id == image_id then
        similar_image = Image.find(image_id)
        #similar_image.rating = rating
        [similar_image, rating, "without"]
      end
    }
    (similar_without_tags).compact.each { |similar_image, rating, join_type|
      similarity = Similarity.new
      similarity.image_id = image.id
      similarity.similar_image_id = similar_image.id
      similarity.rating = rating
      similarity.join_type = join_type
      similarity.save
    }
  }
}
