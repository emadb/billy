class InboundInvoicesController < ApplicationController
  def index
    if (params[:date].nil?)
      @filter_date  = Date.today
    else
      @filter_date= Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
    end
    filter_date_next = @filter_date.to_time.advance(:months => 1).to_date


    @invoices = InboundInvoice
      .where('date >= ? and date <= ?', @filter_date, filter_date_next)
      .order('due_date DESC')

    @totals = InvoiceTotalsInfo.new(InboundInvoice.sum(:taxable_income), InboundInvoice.sum(:tax), InboundInvoice.sum(:total))
  end

  def new
    @invoice = InboundInvoice.new
    @invoice.date = Date.today    
    @totals = InvoiceTotalsInfo.new(0, 0, 0)
  end

  def create
    @invoice = InboundInvoice.create(params[:inbound_invoice])
    @invoice.save
    redirect_to inbound_invoices_path
  end

  def destroy
    @invoice = InboundInvoice.find(params[:id])
    @invoice.destroy
    redirect_to inbound_invoices_url
  end
end
