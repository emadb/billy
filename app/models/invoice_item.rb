class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :amount, :description
end
