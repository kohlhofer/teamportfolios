class MakeUnvalidatedContributorsUseEmailAddressesTable < ActiveRecord::Migration
  def self.up
  add_column :unvalidated_contributors, :email_address_id, :integer
    
    UnvalidatedContributor.all.each do |uvc|
      unless uvc.email.blank?
        email_address = EmailAddress.find_by_email(uvc.email)
        if email_address.nil?
          begin
          email_address = EmailAddress.new(:email=>uvc.email)
          email_address.save!
        rescue
          puts "couldn't fix email #{uvc.email} (uvc##{uvc.id})"
          end
        end
        uvc.email_address = email_address
        uvc.save!
      end
    end
    remove_column :unvalidated_contributors, :email    
  end
  
  def self.down
    add_column :unvalidated_contributors, :email, :string
    UnvalidatedContributor.all.each do |uvc|
      uvc.email = uvc.email_address.email unless uvc.email_address.nil?
    end
    remove_column :unvalidated_contributors, :email_address_id
  end
end
