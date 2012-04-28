class InvoiceController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
    @invoice.number = (Invoice.max(:number) || 0) + 1
    @invoice.date = Date.new  
    @customers = Customer.all
  end
end
