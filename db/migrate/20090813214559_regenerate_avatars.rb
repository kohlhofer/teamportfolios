class RegenerateAvatars < ActiveRecord::Migration
  def self.up
    Avatar.all.each{|avatar| avatar.save if avatar.parent_id.nil?}
  end

  def self.down
  end
end
