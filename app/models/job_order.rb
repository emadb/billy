class JobOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :activities, :foreign_key => 'job_order_id', :class_name => "JobOrderActivity"
  
  attr_accessible :activities, :archived, :code, :notes, :customer_id, 
  :hourly_rate, :activities_attributes, :price

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :activities, :allow_destroy => true

  def self.create_new
    job_order = JobOrder.new
    job_order.activities.push(JobOrderActivity.new)
    job_order.activities.push(JobOrderActivity.new)
    job_order.customer = Customer.new

    return job_order
  end

  def a_project?
    if not self.price.nil? and self.price > 0
      price
    end
  end

  def total_estimated_hours
    activities.sum(:estimated_hours)
  end

  def total_executed_hours
    activities.joins(:user_activities).sum(:hours).to_f
  end

  def percent
    if total_estimated_hours != 0
      percent = (total_executed_hours / total_estimated_hours * 100).ceil
    else
      0
    end
  end

  def total_consumed_cost

    query = "select sum(ua.hours * u.hourly_cost) as cost
              from user_activities ua 
              inner join users u on ua.user_id = u.id 
              inner join job_order_activities joa on joa.id = ua.job_order_activity_id
              where joa.job_order_id = " + self.id.to_s
    sum = ActiveRecord::Base.connection.execute(query)
    sum[0]["cost"].to_f
  end

  def active_activities
    activities.where(:active => true)
  end

  def warning?
    total_executed_hours > total_estimated_hours
  end
end
