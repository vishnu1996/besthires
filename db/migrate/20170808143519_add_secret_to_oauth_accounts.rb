class AddSecretToOauthAccounts < ActiveRecord::Migration
  def change
    add_column :oauth_accounts, :secret, :string
  end
end
