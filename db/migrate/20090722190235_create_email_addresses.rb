class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.string :email
      t.belongs_to :user
    end
    
    User.all.each do |user|
      addr = user.email_addresses.create(:email=>user.email)
      user.save!
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
