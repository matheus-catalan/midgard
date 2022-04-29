class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :email, null: false, unique: true
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
