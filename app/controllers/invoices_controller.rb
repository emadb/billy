class InvoicesController < ApplicationController
  before_filter :user_is_admin?
  def index
    @invoices = Invoice.order(:number)
    @totals = InvoiceTotalsInfo.new(Invoice.sum('taxable_income'), Invoice.sum('tax'), Invoice.sum('total'))
  end

  def new
    @invoice = Invoice.create_new    
    @customers = Customer.all
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

  def activate
    @invoice = Invoice.find(params[:invoice_id])
    @invoice.activate
    @invoice.save
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
    @invoice.status = Invoice.active unless @invoice.number.nil?
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
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}"
    full_path = Rails.root.join('tmp', file_name)
    render  :pdf => full_path,
            :layout => 'pdf_invoice.html',
            :save_to_file => full_path,
            :margin => { :bottom => 15 },
            :footer => {
              :content => '<div class="container" style="text-align:center;color:#777777;font-size:12px;font-family: Helvetica Neue,Helvetica"><p><strong>CodicePlastico srl</strong> - www.codiceplastico.com - Tel: +39 030 6595 241</br>P.IVA, CF e Registro Imprese di Brescia 03079830984 Capitale Sociale : Euro 10.000,00 i.v.</p></div>'
            
            }

    #if !ENV['DROPBOX_FOLDER']
    drop_box = DropBoxService.new
    drop_box.upload file_name, full_path
    #end
    #File.delete full_path
  end
end
