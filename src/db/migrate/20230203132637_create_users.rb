class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    # DBのインデックスとして設定すると検索の高速化が見込める (ここでunique制約を付与)
    add_index :users, :email, unique: true
  end
end
