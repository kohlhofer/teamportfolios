class User < ActiveRecord::Base 
  has_many :email_addresses, :dependent=>:destroy
end
class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    begin
      create_table :email_addresses do |t|
        t.string :email
        t.belongs_to :user
      end
    rescue Exception => e
      puts "warning: couldn't create email addresses: #{e}"
    end
    User.all.each do |user|
      EmailAddress.create(:user_id=>user.id, :email=>user.email)
    end
    remove_column :users, :email    
  end
  
  def self.down
    add_column :users, :email, :string
    User.all.each do |user|
      user.email = user.email_addresses[0].email unless user.email_addresses.size ==0
    end
    drop_table :email_addresses
  end
end
