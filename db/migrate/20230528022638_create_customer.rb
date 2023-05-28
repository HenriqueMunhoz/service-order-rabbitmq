class CreateCustomer < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :identification_code, null: false

      t.timestamps
      t.index :email, unique: true
    end
  end
end
