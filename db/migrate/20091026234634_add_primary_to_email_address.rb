class AddPrimaryToEmailAddress < ActiveRecord::Migration
  def self.up
    add_column :email_addresses, :primary, :boolean, :default=>true
    EmailAddress.update_all(:primary=>true)
  end

  def self.down
    remove_column :email_addresses, :primary
  end
end
