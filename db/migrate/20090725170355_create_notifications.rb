class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :email_address_id
      t.string :action, :length => 30
      t.datetime :attempted_send
      t.string :failure_msg
      
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
