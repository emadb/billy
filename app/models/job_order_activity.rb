class JobOrderActivity < ActiveRecord::Base
  belongs_to :job_order
  attr_accessible :description, :estimated_hours, :active
  has_many :user_activities

  after_initialize :init
  
  def init
    if self.new_record?
      self.active = true
    end
  end
end
