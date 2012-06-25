class JobOrder
  include Mongoid::Document
  field :code, type: String
  field :notes, type: String
  field :hourly_rate, type: Float
  field :archived?, type: Boolean
  
  embeds_one :customer
  embeds_many :activities

  accepts_nested_attributes_for :customer, :activities

  def self.create_new
    @job_order = JobOrder.new
    @job_order.activities.push(Activity.new)
    @job_order.activities.push(Activity.new)
    @job_order.customer = Customer.new

    return @job_order
  end
end

