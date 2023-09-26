class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 32
      t.index :username, unique: true
      t.string :password_digest

      t.timestamps
    end
  end
end
