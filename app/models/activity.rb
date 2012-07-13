class Activity
  include Mongoid::Document
  embedded_in :job_order, :inverse_of => :activities 
  field :description, :type => String
  field :estimated_hours, :type => Integer
  field :job_order_code
end


