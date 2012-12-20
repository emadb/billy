class JobOrderActivity < ActiveRecord::Base
  belongs_to :job_order
  attr_accessible :description, :estimated_hours
end
