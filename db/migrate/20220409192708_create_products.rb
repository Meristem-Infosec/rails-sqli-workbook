class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :image_url
      t.decimal :cost

      t.timestamps
    end
  end
end
