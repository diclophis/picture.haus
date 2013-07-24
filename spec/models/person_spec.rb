require 'spec_helper'

describe Person do
  def valid_person
    person = Person.new
    person.username = "foo"
    person.email = "foo@foo.com"
    person.password = "qwerty123"
    person.should be_valid
    person
  end

  it "should have a username, email and password" do
    person = valid_person
    person.save.should be_true
  end
end
