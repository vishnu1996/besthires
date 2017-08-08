class CreateOauthAccounts < ActiveRecord::Migration
  def change
    create_table :oauth_accounts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :image_url
      t.string :profile_url
      t.string :access_token
      t.string :secret
      t.text :raw_data
      t.timestamps null: false
    end
  end
end