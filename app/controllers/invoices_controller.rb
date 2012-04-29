class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
    @invoice.number = (Invoice.max(:number) || 0) + 1
    @invoice.due_date = Date.new  
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)
    @invoice.invoice_items.push(InvoiceItem.new)


    

    @customers = Customer.all.map{|c| [c.name, c._id]}
  end
end
