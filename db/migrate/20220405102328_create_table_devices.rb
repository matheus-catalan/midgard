class CreateTableDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :name, null: false
      t.string :ip_address, null: false
      t.string :user_agent, null: false
      t.string :platform, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
