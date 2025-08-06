class CreateSiteContents < ActiveRecord::Migration[8.0]
  def change
    create_table :site_contents do |t|
      t.string :page_name
      t.string :section
      t.text :content
      t.boolean :active

      t.timestamps
    end
  end
end
