class Invoice
  include Mongoid::Document
  embeds_one :customer
  embeds_many :invoice_items

  accepts_nested_attributes_for :customer, :invoice_items

  field :number, :type => Integer
  field :date, :type => Date
  field :due_date, :type => Date

  field :total, :type => Float
  field :tax, :type => Float
  field :taxable_income, :type => Float

  field :has_tax, :type => Boolean
  field :notes, :type => String

  field :is_payed, :type => Boolean
  field :is_sent, :type => Boolean

  def self.create_new
    @invoice = Invoice.new
    @invoice.number = (Invoice.max(:number) || 0) + 1
    @invoice.date = DateTime.now  
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)
    return @invoice
  end

end


class InvoiceItem
  include Mongoid::Document
  embedded_in :invoice, :inverse_of => :invoice_items 
  field :description, :type => String
  field :amount, :type => Float
end