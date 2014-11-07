class InboundInvoice < ActiveRecord::Base
  belongs_to :job_order
  attr_accessible :job_order_id, :customer, :date, :due_date, :notes, :number, :tax, :taxable_income, :total
end
