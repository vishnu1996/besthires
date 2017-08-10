class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :password_digest, null: false, default: ''
      t.string :auth_token, null: false, default: ''
      t.string :city, null: false, default: ''
      t.string :state, null: false, default: ''
      t.string :country, null: false, default: ''
      t.datetime :last_login_at

      t.timestamps
    end

    add_index :users, :first_name
    add_index :users, :last_name

    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true

    add_index :users, :city
    add_index :users, :state
    add_index :users, :country
  end
end
