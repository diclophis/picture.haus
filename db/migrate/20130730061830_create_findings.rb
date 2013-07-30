class CreateFindings < ActiveRecord::Migration
  def change
    create_table :findings do |t|
      t.integer :person_id
      t.integer :image_id
      t.text :notes
      t.integer :position

      t.timestamps
    end
  end
end
