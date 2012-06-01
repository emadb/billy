class Invoice
  include Mongoid::Document
  embeds_one :customer
  embeds_many :invoice_items
  before_save :update_totals
  accepts_nested_attributes_for :customer, :invoice_items, :allow_destroy => true

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
    today = DateTime.now
    @invoice.date = Date.new(today.year, today.month, 1) - 1
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.customer = Customer.new
    @invoice.has_tax = true

    return @invoice
  end

  def update_totals
    self.taxable_income = self.invoice_items.inject(0) {|tot,item| tot += item.amount }
    self.tax = self.invoice_items.inject(0) { |tot,item| tot += item.amount * 0.21 }
    if self.has_tax then
      self.total = self.taxable_income + self.tax
    else
      self.total = self.taxable_income
    end
  end
end

class InvoiceItem
  include Mongoid::Document
  embedded_in :invoice, :inverse_of => :invoice_items 
  field :description, :type => String
  field :amount, :type => Float
end

class InvoiceTotalsInfo
  attr_accessor :taxable_income, :tax, :total
  def initialize(taxable_income, tax, total)
    @taxable_income = taxable_income
    @tax = tax
    @total = total
  end
end
