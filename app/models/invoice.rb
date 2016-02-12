class Invoice < ActiveRecord::Base
  belongs_to :customer
  attr_accessible :date, :due_date, :has_tax, :is_payed, :notes, :number, :status, :tax, :taxable_income, :total, :fiscal_year
  has_many :invoice_items
  attr_accessible :customer_id, :invoice_items_attributes
  accepts_nested_attributes_for :customer, :invoice_items, :allow_destroy => true
  before_save :update_totals

  scope :actives, -> { where(status: active) }
  scope :year, ->(year) {where('date is null or date between ? and ?', DateHelper.new_years_day(year), DateHelper.end_year(year)) }
  scope :year_month, ->(year, month) {where('date between ? and ?', Date.new(year.to_i, month.to_i, 1), Date.new(year.to_i, month.to_i, Time.days_in_month(month.to_i, year.to_i))) }
  scope :current_year, -> {where('date is null or date between ? and ?', DateHelper.new_years_day(AppSettings.fiscal_year), DateHelper.end_year(AppSettings.fiscal_year)) }

  def self.create_new
    invoice = Invoice.new
    invoice.number = nil
    invoice.invoice_items.push(InvoiceItem.new)
    invoice.invoice_items.push(InvoiceItem.new)
    invoice.customer = Customer.new
    invoice.has_tax = true
    invoice.status = 1

    return invoice
  end

  def self.temporary
    1
  end

  def self.active
    2
  end

  def activate
    if self.number.nil?
      self.number = (Invoice.current_year.maximum(:number) || 0) + 1
    end
    if self.date.nil?
      self.date = Date.new(Date.today.year, Date.today.month, 1) - 1
      self.due_date = self.date + 30
    end
    self.status = Invoice.active
  end

  def update_totals
    self.taxable_income = self.invoice_items.inject(0){|t, i| t + i.amount}
    if self.has_tax 
      self.tax = self.taxable_income * AppSettings.iva.to_f
    else
      self.tax = 0
    end
    self.total = self.taxable_income + self.tax
  end
  
  def is_in_late?
    !self.due_date.nil? and self.due_date <= DateTime.now && !self.is_payed
  end

  def string_date
    self.date.strftime('%d/%m/%Y') unless self.date.nil?
  end

  def string_due_date
    self.due_date.strftime('%d/%m/%Y') unless self.due_date.nil?
  end

  def fiscal_year
    self.date.year
  end

  def clone
    invoice = Invoice.create_new
    invoice.customer = self.customer
    invoice.notes = self.notes

    invoice.invoice_items.clear
    self.invoice_items.each do |i|
      item = InvoiceItem.new
      item.description = i.description
      item.amount = i.amount
      invoice.invoice_items << item
    end

    invoice.taxable_income = self.taxable_income
    invoice.total =  self.total
    invoice.has_tax = self.has_tax
    
    invoice
  end
end
