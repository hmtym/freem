class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.string :name
      t.text :description
      t.integer :price
      t.string :image1
      t.string :image2
      t.string :image3
      t.integer :status

      t.timestamps
    end
  end
end
