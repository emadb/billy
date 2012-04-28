class Invoice
  include Mongoid::Document
  embeds_one :customer
  embeds_many :invoice_item

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :invoice_item

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

end


class InvoiceItem
  include Mongoid::Document

  field :description, :type => String
  field :amount, :type => Float
end