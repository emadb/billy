class InvoiceItem
  include Mongoid::Document
  embedded_in :invoice, :inverse_of => :invoice_items 
  field :description, :type => String
  field :amount, :type => Float
end