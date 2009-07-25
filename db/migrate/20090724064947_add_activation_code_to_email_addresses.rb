class AddActivationCodeToEmailAddresses < ActiveRecord::Migration
  def self.up
    add_column :email_addresses, :activation_code, :string, :length=>40
    add_column :email_addresses, :activated_at, :datetime
    add_column :email_addresses, :created_at, :datetime
    add_index :email_addresses, :email, :unique => true
    
    EmailAddress.all.each do |eml|
      eml.created_at = Time.now
      if eml.user.nil?
        eml.activation_code = User.make_token
      else
        eml.activated_at = Time.now
      end
      puts eml.email
      if !eml.save
        eml.destroy
      end
    end
  end
  
  def self.down
    remove_column :email_addresses, :activation_code
    remove_column :email_addresses, :activated_at
    remove_column :email_addresses, :created_at
    remove_index :email_addresses, :email
  end
end

