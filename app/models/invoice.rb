class Invoice < ActiveRecord::Base
  belongs_to :customer
  attr_accessible :date, :due_date, :has_tax, :is_payed, :notes, :number, :status, :tax, :taxable_income, :total, :fiscal_year
  has_many :invoice_items
  attr_accessible :customer_id, :invoice_items_attributes
  accepts_nested_attributes_for :customer, :invoice_items, :allow_destroy => true
  before_save :update_totals

  scope :actives, -> { where(status: active) }
  scope :fiscal_year, ->(year) {where('date between ? and ?', Date.new(year.to_i, 1, 1), Date.new(year.to_i, 12, 31)) }
  scope :year_month, ->(year, month) {where('date between ? and ?', Date.new(year.to_i, month.to_i, 1), Date.new(year.to_i, month.to_i, Time.days_in_month(month.to_i, year.to_i))) }
  scope :current_year, -> {where('date between ? and ?', Date.new(AppSettings.fiscal_year.to_i, 1, 1), Date.new(AppSettings.fiscal_year.to_i, 12, 31)) }

  def self.create_new
    @invoice = Invoice.new
    @invoice.number = nil
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.customer = Customer.new
    @invoice.has_tax = true
    @invoice.status = 1

    return @invoice
  end

  def self.temporary
    1
  end

  def self.active
    2
  end

  def activate
    if self.number.nil?
      self.number = (Invoice.maximum(:number) || 0) + 1
    end
    if self.date.nil?
      self.date = Date.new(Date.today.year, Date.today.month, 1) - 1
      self.due_date = self.date + 30
    end
    self.status = Invoice.active
  end

  def update_totals
    self.taxable_income = self.invoice_items.sum(:amount)

    if self.has_tax then
      self.tax = self.taxable_income * AppSettings.iva
      self.total = self.taxable_income + self.tax
    else
      self.total = self.taxable_income
      self.tax = 0
    end
  end
  
  def is_in_late?
    !self.due_date.nil? and self.due_date <= DateTime.now && !self.is_payed
  end

  def string_date
    self.date.strftime('%d-%m-%Y') unless self.date.nil?
  end

  def string_due_date
    self.due_date.strftime('%d-%m-%Y') unless self.due_date.nil?
  end

  def fiscal_year
    self.date.year
  end
end
