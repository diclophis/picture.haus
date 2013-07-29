class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|

      t.column "person_id", :integer, :null => false
      t.column "friend_id", :integer, :null => false
      t.column "accepted_at", :datetime

      t.timestamps
    end
  end
end
