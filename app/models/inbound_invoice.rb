class InboundInvoice
  include Mongoid::Document

  field :customer, :type => String
  field :number, :type => String
  field :date, :type => Date
  field :due_date, :type => Date

  field :total, :type => Float
  field :tax, :type => Float
  field :taxable_income, :type => Float

  field :notes, :type => String
end