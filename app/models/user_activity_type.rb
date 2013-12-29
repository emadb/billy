class UserActivityType < ActiveRecord::Base
  belongs_to :user_activity
  attr_accessible :description
end
