class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.create_new
    @customers = Customer.all.map{|c| [c.name, c._id]}
  end

  def create
    @invoice = Invoice.new
    @invoice.number = params[:invoice][:number]
    @invoice.due_date = params[:invoice][:due_date]
    @invoice.customer = Customer.find(params[:invoice][:customer])
    @invoice.has_tax = params[:has_tax]
    @invoice.is_sent = params[:is_sent]
    @invoice.is_payed = params[:is_payed]

    #TODO invoice_items
    
    logger.info '************************************'
    logger.info @invoice.to_json
    @invoice.save
    redirect_to invoices_path
  end
end
