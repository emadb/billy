class InboundInvoice < ActiveRecord::Base
  attr_accessible :customer, :date, :due_date, :notes, :number, :tax, :taxable_income, :total
end
