class RevertPasswordFieldsInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_hash, :string
    remove_column :users, :password_salt, :string
    add_column :users, :password_digest, :string
  end
end
