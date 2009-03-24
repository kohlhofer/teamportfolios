class GenerateCoreUsers < ActiveRecord::Migration
  def self.up
      User.new(
      :login=>"alex",
      :email=>'alex@teamportfolios.com',
      :name=>"Alexander Kohlhofer",
      :password =>'alexpass',
      :password_confirmation =>'alexpass'
      ).save()
      User.new(
      :login=>"tim",
      :email=>'tim@teamportfolios.com',
      :name=>"Tim Diggins",
      :password =>'timpass',
      :password_confirmation =>'timpass'
      ).save()
  end

  def self.down
    User.find_by_login('alex').destroy
    User.find_by_login('tim').destroy
  end
end
