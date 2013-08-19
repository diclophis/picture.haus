class AddAuthenticationTokenToPeople < ActiveRecord::Migration
  def change
    add_column :people, :authentication_token, :string
  end
end
