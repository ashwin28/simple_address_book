class ChangeOauthExpiresAtDefaultValueInUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :oauth_expires_at, nil)
  end
end
