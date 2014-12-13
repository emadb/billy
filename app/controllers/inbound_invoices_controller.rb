class InboundInvoicesController < ApplicationController
  before_filter :user_is_admin?
  def index
    if (params[:date].nil?)
      @filter_date  = Date.today.beginning_of_month
    else
      @filter_date= Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
    end
    filter_date_next = @filter_date + 1.month

    @invoices = InboundInvoice
      .where('date >= ? and date <= ?', @filter_date, filter_date_next)
      .order('due_date DESC')
    taxable_income  = InboundInvoice.where('date >= ? and date <= ?', @filter_date, filter_date_next).sum(:taxable_income)
    tax = InboundInvoice.where('date >= ? and date <= ?', @filter_date, filter_date_next).sum(:tax)
    total = InboundInvoice.where('date >= ? and date <= ?', @filter_date, filter_date_next).sum(:total)
    @totals = InvoiceTotalsInfo.new(taxable_income, tax, total)
  end

  def new
    @invoice = InboundInvoice.new
    @invoice.date = Date.today    
    @totals = InvoiceTotalsInfo.new(0, 0, 0)
    @job_orders = JobOrder.where(:archived => false).order('code')
    @invoice.job_order = @job_orders[0]
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
