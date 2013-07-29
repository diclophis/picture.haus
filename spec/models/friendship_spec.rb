require 'spec_helper'

describe Friendship do
  it "can be valid" do
    friendship = valid_friendship
    valid_friendship.should be_valid
    valid_friendship.save!
  end
end
