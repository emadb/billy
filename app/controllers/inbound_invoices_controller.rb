class InboundInvoicesController < ApplicationController
  def index
    @invoices = InboundInvoice.all.order_by([:due_date, :desc])
    @totals = InvoiceTotalsInfo.new(@invoices.sum(:taxable_income), @invoices.sum(:tax), @invoices.sum(:total))
  end

  def new
    @invoice = InboundInvoice.new    
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
