module HasManyFriends

  module UserExtensions
  
    def self.included( recipient )
      recipient.extend( ClassMethods )
    end
    
    module ClassMethods
      def has_many_friends(options={})
        has_many :friendships_by_me,
                 :foreign_key => 'person_id',
                 :class_name => 'Friendship',
                 :dependent => :destroy
        
        has_many :friendships_for_me,
                 :foreign_key => 'friend_id',
                 :class_name => 'Friendship',
                 :dependent => :destroy
        
        has_many :friends_by_me, -> { where('accepted_at IS NOT NULL') },
                 :through => :friendships_by_me,
                 :source => :friendshipped_for_me,
                 :dependent => :destroy
        
        has_many :friends_for_me, -> { where('accepted_at IS NOT NULL') },
                 :through => :friendships_for_me,
                 :source => :friendshipped_by_me,
                 :dependent => :destroy

    #has_many :spam_comments, conditions: { spam: true }, class_name: 'Comment'
    #should be rewritten as the following:
    #has_many :spam_comments, -> { where spam: true }, class_name: 'Comment'

        has_many :pending_friends_by_me, -> { where('accepted_at IS NULL') },
                 :through => :friendships_by_me,
                 :source => :friendshipped_for_me,
                 :dependent => :destroy
        
        has_many :pending_friends_for_me, -> { where('accepted_at IS NULL') },
                 :through => :friendships_for_me,
                 :source => :friendshipped_by_me,
                 :dependent => :destroy
        
        include HasManyFriends::UserExtensions::InstanceMethods
      end
    end
    
    module InstanceMethods
      
      # Returns a list of all of a users accepted friends.
      def friends
        self.friends_for_me + self.friends_by_me
      end
      
      # Returns a list of all pending friendships.
      def pending_friends
        self.pending_friends_by_me + self.pending_friends_for_me
      end
      
      # Returns a full list of all pending and accepted friends.
      def pending_or_accepted_friends
        self.friends + self.pending_friends
      end
      
      # Accepts a user object and returns the friendship object 
      # associated with both users.
      def friendship(friend)
        Friendship.where(['(person_id = ? AND friend_id = ?) OR (friend_id = ? AND person_id = ?)', self.id, friend.id, self.id, friend.id]).first
      end
      
      # Accepts a user object and returns true if both users are
      # friends and the friendship has been accepted.
      def is_friends_with?(friend)
        self.friends.include?(friend)
      end
      
      # Accepts a user object and returns true if both users are
      # friends but the friendship hasn't been accepted yet.
      def is_pending_friends_with?(friend)
        self.pending_friends.include?(friend)
      end
      
      # Accepts a user object and returns true if both users are
      # friends regardless of acceptance.
      def is_friends_or_pending_with?(friend)
        self.pending_or_accepted_friends.include?(friend)
      end
      
      # Accepts a user object and creates a friendship request
      # between both users.
      def request_friendship_with(friend)
        Friendship.create!(:friendshipped_by_me => self, 
                           :friendshipped_for_me => friend) unless self.is_friends_or_pending_with?(friend) || self == friend
      end
      
      # Accepts a user object and updates an existing friendship to
      # be accepted.
      def accept_friendship_with(friend)
        self.friendship(friend).update_attribute(:accepted_at, Time.now)
      end
      
      # Accepts a user object and deletes a friendship between both 
      # users.
      def delete_friendship_with(friend)
        self.friendship(friend).destroy if self.is_friends_or_pending_with?(friend)
      end
      
      # Accepts a user object and creates a friendship between both 
      # users. This method bypasses the request stage and makes both
      # users friends without needing to be accepted.
      def become_friends_with(friend)
        unless self.is_friends_with?(friend)
          unless self.is_pending_friends_with?(friend)
            Friendship.create!(:friendshipped_by_me => self, :friendshipped_for_me => friend, :accepted_at => Time.now)
          else
            self.friendship(friend).update_attribute(:accepted_at, Time.now)
          end
        else
          self.friendship(friend)
        end
      end
    end  
  end
end
