class AddResetPasswordCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password_code, :string
  end

  def self.down
    remove_column :users, :reset_password_code
  end
end
