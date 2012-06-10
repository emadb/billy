class InboundInvoicesController < ApplicationController
  def index

    if (params[:date].nil?)
      @filter_date  = Date.today
    else
      @filter_date= Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
    end
    filter_date_next = @filter_date.to_time.advance(:months => 1).to_date
    @invoices = InboundInvoice
      .where(:date.gte => @filter_date)
      .where(:date.lte => filter_date_next)
      .order_by([:due_date, :desc])
    @totals = InvoiceTotalsInfo.new(@invoices.sum(:taxable_income), @invoices.sum(:tax), @invoices.sum(:total))
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


class InvoiceTotalsInfo
  attr_accessor :taxable_income, :tax, :total
  def initialize(taxable_income, tax, total)
    @taxable_income = taxable_income
    @tax = tax
    @total = total
  end
end
