class UserActivityType < ActiveRecord::Base
  attr_accessible :description, :isWorking

  def working?
  	self.isWorking
  end

  def self.working_id 
  	UserActivityType.where(isWorking: true).first
  end
end
