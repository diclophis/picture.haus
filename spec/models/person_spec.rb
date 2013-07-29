require 'spec_helper'

describe Person do
  describe "validations" do
    before :each do
      @person = valid_person
      @person.should be_valid
    end

    it "should have a username" do
      @person.username = ""
      @person.should_not be_valid
    end

    it "should have a email" do
      @person.email = ""
      @person.should_not be_valid
    end

    it "should have a password" do
      @person.password = ""
      @person.should_not be_valid
    end
  end

  it "should have friends" do
    user = valid_person
    user.save!

    friend = valid_person
    friend.save!

    user.is_friends_with?(friend).should == false

    friendship = user.request_friendship_with(friend)
    friendship.should be_valid

    user.reload.is_pending_friends_with?(friend).should == true
    friend.reload.is_pending_friends_with?(user).should == true

    user.pending_friends.should include(friend)
    friend.pending_friends.should include(user)

    friend.accept_friendship_with(user).should == true

    user.reload.is_pending_friends_with?(friend).should == false
    friend.reload.is_pending_friends_with?(user).should == false

    user.is_friends_with?(friend).should == true
    friend.is_friends_with?(user).should == true

    user.friends_by_me.should include(friend)
    user.friends_for_me.should_not include(friend)

    friend.friends_for_me.should include(user)
    friend.friends_by_me.should_not include(user)

    user.delete_friendship_with friend

    user.reload.is_pending_friends_with?(friend).should == false
    friend.reload.is_pending_friends_with?(user).should == false

    user.is_friends_with?(friend).should == false
    friend.is_friends_with?(user).should == false

=begin
    # misc
    user.pending_friends_for_me
    user.pending_friends_by_me
    user.friends
    user.pending_friends
    user.pending_or_accepted_friends
    user.friendship friend
    # testers
    user.is_friends_or_pending_with? friend
    # crud
    user.become_friends_with! friend
=end

  end
end
