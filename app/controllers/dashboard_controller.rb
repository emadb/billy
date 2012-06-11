class DashboardController < ApplicationController
  def index
    invoices = Invoice.all
    @to_receive = 0
    invoices.each{ |x| @to_receive = @to_receive + x.total unless x.is_payed }
    @invoices_totals = InvoiceTotalsInfo.new(invoices.sum(:taxable_income), invoices.sum(:tax), invoices.sum(:total))

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
