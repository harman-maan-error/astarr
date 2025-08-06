class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.text :specifications
      t.decimal :base_price
      t.references :category, null: false, foreign_key: true
      t.string :iphone_model
      t.string :color
      t.string :material
      t.boolean :is_featured
      t.boolean :is_on_sale
      t.decimal :sale_price
      t.integer :stock_quantity
      t.boolean :active
      t.decimal :average_rating
      t.integer :reviews_count

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
