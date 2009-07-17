class UserLink < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :label
  validates_presence_of :url
end
