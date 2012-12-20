class Invoice < ActiveRecord::Base
  belongs_to :customer
  attr_accessible :date, :due_date, :has_tax, :is_payed, :notes, :number, :status, :tax, :taxable_income, :total
  has_many :invoice_items
  attr_accessible :customer_id, :invoice_items_attributes
  accepts_nested_attributes_for :customer, :invoice_items, :allow_destroy => true

  def self.create_new
    @invoice = Invoice.new
    @invoice.number = (Invoice.maximum(:number) || 0) + 1
    today = DateTime.now
    @invoice.date = Date.new(today.year, today.month, 1) - 1
    @invoice.due_date = @invoice.date + 30
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
