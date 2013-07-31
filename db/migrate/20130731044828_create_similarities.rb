class CreateSimilarities < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.integer :image_id
      t.integer :similar_image_id
      t.float :rating
      t.string :join_type, :limit => 255, :null => false
      t.timestamps
    end
  end
end
