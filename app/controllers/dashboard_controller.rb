class DashboardController < ApplicationController
  def index
    invoices = Invoice.all
    @to_receive = 0
    invoices.each{ |x| @to_receive = @to_receive + x.total unless x.is_payed }
    @invoices_totals = InvoiceTotalsInfo.new(invoices.sum(:taxable_income), invoices.sum(:tax), invoices.sum(:total))

    @quarters = Quarters.new
    invoices.each do |i|
      @quarters.q1  = @quarters.q1 + i.taxable_income if [1,2,3].include?(i.date.month)
      @quarters.q2  = @quarters.q2 + i.taxable_income if [4,5,6].include?(i.date.month)
      @quarters.q3  = @quarters.q3 + i.taxable_income if [7,8,9].include?(i.date.month)
      @quarters.q4  = @quarters.q4 + i.taxable_income if [10, 11, 12].include?(i.date.month)
    end
  map = %Q{
    function() {
      emit(this.customer.name, {customer: this.customer.name, value: this.taxable_income });
    }
  }

  reduce = %Q{
    function(key, values) {
      var result = { customer: key, value: 0 };
      values.forEach(function(value) {
        result.value += value.value;
      });
      return result;
    }
  }

    @perCustomer = Invoice.map_reduce(map, reduce).out(inline: 1)

    inbound_invoices = InboundInvoice.all
    @inbound_invoices_totals = InvoiceTotalsInfo.new(inbound_invoices.sum(:taxable_income), inbound_invoices.sum(:tax), inbound_invoices.sum(:total))
  end
end

# Totale inbound (numero fatture, fatturato)

# Totali outbuound (numero fatture, fatturato)
# => per trimestre
# => per cliente

# Totale attivita per mese


# job_order
# => name
# => customer
# => notes
# => hourly rate
# => activities
# => => name
# => => estimated time
# => => 
