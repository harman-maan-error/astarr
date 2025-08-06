class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.boolean :is_premium
      t.decimal :price_multiplier

      t.timestamps
    end
    add_index :categories, :slug, unique: true
  end
end
