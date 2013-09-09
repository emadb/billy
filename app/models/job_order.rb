class JobOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :activities, :foreign_key => 'job_order_id', :class_name => "JobOrderActivity"
  
  attr_accessible :activities, :archived, :code, :notes, :customer_id, :hourly_rate, :activities_attributes

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :activities, :allow_destroy => true

  def self.create_new
    job_order = JobOrder.new
    job_order.activities.push(JobOrderActivity.new)
    job_order.activities.push(JobOrderActivity.new)
    job_order.customer = Customer.new

    return job_order
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

  # TODO: write SQL query
  def total_estimated_cost
    total_estimated_hours * self.hourly_rate
  end

  # TODO: write SQL query
  def total_consumed_cost
    sum = 0
    activities.joins(:user_activities).each do |a|
      sum = a.user_activities.reduce(0){|sum, a| sum + a.cost} 
    end
    sum.to_f
  end

  def active_activities
    activities.where(:active => true)
  end

  def warning?
    total_executed_hours > total_estimated_hours
  end
end
