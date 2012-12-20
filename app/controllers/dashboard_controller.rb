class DashboardController < ApplicationController
  def index
    invoices = Invoice.all
    @to_receive = 0
    invoices.each{ |x| @to_receive = @to_receive + (x.total || 0) unless x.is_payed }
    @invoices_totals = InvoiceTotalsInfo.new(Invoice.sum(:taxable_income), Invoice.sum(:tax), Invoice.sum(:total))

    @quarters = Quarters.new
    #TODO: refactor this...it's too c-sharpy!
    invoices.each do |i|
      @quarters.q1  = @quarters.q1 + i.taxable_income if [1,2,3].include?(i.date.month)
      @quarters.q2  = @quarters.q2 + i.taxable_income if [4,5,6].include?(i.date.month)
      @quarters.q3  = @quarters.q3 + i.taxable_income if [7,8,9].include?(i.date.month)
      @quarters.q4  = @quarters.q4 + i.taxable_income if [10, 11, 12].include?(i.date.month)
    end
 
    @perCustomer = []# Invoice.map_reduce(map, reduce).out(inline: 1)

    inbound_invoices = InboundInvoice.all
    @inbound_invoices_totals = InvoiceTotalsInfo.new(InboundInvoice.sum(:taxable_income), 
      InboundInvoice.sum(:tax), 
      InboundInvoice.sum(:total))
  end
end
