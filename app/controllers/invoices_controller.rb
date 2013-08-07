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
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}.pdf"
    render pdf: file_name,
      template: 'invoices/show.pdf.html.erb',
      :margin => { :bottom => 15 },
      :footer => {
        :content => AppSettings.footer
      }
  end

  def drop_box
    @invoice = Invoice.find(params[:invoice_id])
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}.pdf"
    full_path = Rails.root.join('tmp', file_name)
  
    pdf = render_to_string(
            :pdf => file_name,
            :template => 'invoices/show.pdf.html.erb',
            :margin => { :bottom => 15 },
            :footer => {
              :content => AppSettings.footer
            })
    
    if AppSettings.dropbox_enabled?
      drop_box = DropBoxService.new
      drop_box.upload file_name, pdf
    end
    render :json => {satus: 'success'}
  end
end
