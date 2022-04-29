class CreateTableSession < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.boolean :should_expire, null: false, default: true

      t.timestamps
    end
  end
end
