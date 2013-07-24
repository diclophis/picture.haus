class AddUsernameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :username, :string, :null => false, :default => ""
  end
end
