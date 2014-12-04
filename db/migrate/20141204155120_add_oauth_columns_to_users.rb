class AddOauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider_name,    :string,   default: ""
    add_column :users, :provider_uid,     :string,   default: ""
    add_column :users, :oauth_token,      :string,   default: ""
    add_column :users, :oauth_expires_at, :datetime, default: ""
  end
end
