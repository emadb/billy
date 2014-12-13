class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :amount, :description
  default_scope {order(:id)}
end
