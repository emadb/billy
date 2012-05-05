class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.create_new
    @invoice.has_tax = true
    @customers = Customer.all #.map{|c| [c.name, c._id]}
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.customer = Customer.find(params[:invoice][:customer_id])
    @invoice.invoice_items = @invoice.invoice_items.delete_if {|i| i.description.empty?}
      
    # @invoice.number = params[:invoice][:number]
    # @invoice.due_date = params[:invoice][:due_date]
    # @invoice.customer = Customer.find(params[:invoice][:customer])
    # @invoice.has_tax = params[:has_tax]
    # @invoice.is_sent = params[:is_sent]
    # @invoice.is_payed = params[:is_payed]
    #TODO invoice_items
    
    @invoice.save
    redirect_to invoices_path
  end

  def edit  
    @invoice = Invoice.find(params[:id])
    @customers = Customer.all #.map{|c| [c.name, c._id]}
  end

  def update  
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(params[:invoice])
    redirect_to invoices_path
  end

end
