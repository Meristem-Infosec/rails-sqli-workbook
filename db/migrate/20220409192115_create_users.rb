class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :pw_hash
      t.boolean :is_admin

      t.timestamps
    end
  end
end
