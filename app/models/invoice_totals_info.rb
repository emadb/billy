class InvoiceTotalsInfo
  attr_accessor :taxable_income, :tax, :total
  
  def initialize(taxable_income, tax, total)
    @taxable_income = taxable_income
    @tax = tax
    @total = total
  end
end