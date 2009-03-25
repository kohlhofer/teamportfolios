class Project < ActiveRecord::Base
  alias_attribute :to_s, :name
  alias_attribute :to_param, :title
end
