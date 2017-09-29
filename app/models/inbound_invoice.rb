class InboundInvoice < ActiveRecord::Base
  belongs_to :job_order
  belongs_to :inbound_invoice_category
  attr_accessible :job_order_id, :customer, :date, :due_date, :notes, :number, :tax, :taxable_income, :total, :inbound_invoice_category_id
end
