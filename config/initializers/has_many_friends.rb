require 'has_many_friends'

ActiveRecord::Base.send(:include, HasManyFriends::UserExtensions)
