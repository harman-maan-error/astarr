class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating
      t.string :title
      t.text :comment
      t.boolean :verified_purchase
      t.boolean :approved

      t.timestamps
    end
  end
end
