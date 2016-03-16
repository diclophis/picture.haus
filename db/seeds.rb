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
