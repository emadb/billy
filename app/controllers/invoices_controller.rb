class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
    @totals = InvoiceTotalsInfo.new(Invoice.sum('taxable_income'), Invoice.sum('tax'), Invoice.sum('total'))
  end

  def new
    @invoice = Invoice.create_new    
    @customers = Customer.all #.map{|c| [c.name, c._id]}
    @totals = InvoiceTotalsInfo.new(0, 0, 0)
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.customer = Customer.find(params[:invoice][:customer_id])
    @invoice.invoice_items = @invoice.invoice_items.delete_if {|i| i.description.empty?}
    @invoice.save
    @invoice.save #TODO: why update_totals doesn't work if I don't call save twice?
    redirect_to invoices_path
  end

  def edit  
    @invoice = Invoice.find(params[:id])
    @customers = Customer.all #.map{|c| [c.name, c._id]}
    @totals = InvoiceTotalsInfo.new(@invoice.taxable_income, @invoice.tax, @invoice.total)
  end

  def update  
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes!(params[:invoice])
    @invoice.save
    redirect_to invoices_path
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to invoices_url
  end

  def show
    @invoice = Invoice.find(params[:id])
    #TODO configure wkpdfhtml
    #WickedPdf.config[:exe_path] = "/usr/local/Cellar/wkhtmltopdf/0.11.0_rc1/bin/wkhtmltopdf" 
    WickedPdf.config[:exe_path] = "/home/ema/Downloads/wkpdf/wkhtmltopdf"
    render  :pdf => "fattura_#{@invoice.number}",
            :layout => 'pdf_invoice.html'
    
  end
end
