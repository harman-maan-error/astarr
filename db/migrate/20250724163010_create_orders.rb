class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.references :user, null: false, foreign_key: true
      t.decimal :subtotal
      t.decimal :tax_amount
      t.decimal :tax_rate
      t.decimal :shipping_cost
      t.decimal :total_amount
      t.string :status
      t.string :payment_status
      t.string :shipping_method
      t.text :notes
      t.string :billing_street_address
      t.string :billing_city
      t.string :billing_province
      t.string :billing_postal_code
      t.string :billing_country
      t.string :shipping_street_address
      t.string :shipping_city
      t.string :shipping_province
      t.string :shipping_postal_code
      t.string :shipping_country
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
