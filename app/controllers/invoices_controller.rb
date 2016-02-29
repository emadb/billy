class InvoicesController < ApplicationController
  before_filter :user_is_admin?
  
  def index
    @customers = Customer.all
    @customer_id = params[:customer]
    
    if params[:date].nil? or params[:date][:year].nil?
      @year = Date.today.year
      @month = nil
      @invoices = Invoice.current_year.order(:number)
      
    else
      if params[:date][:month].nil? or params[:date][:month].blank?
        @invoices = Invoice.year(params[:date][:year])
      else
        @month = params[:date][:month].to_i
        @invoices = Invoice.year_month(params[:date][:year], params[:date][:month])
      end

      @invoices = @invoices.order(:number)
      @invoices = @invoices.where('customer_id = ?', @customer_id) unless @customer_id.empty?
      @year = params[:date][:year].to_i
    end

    @totals = InvoiceTotalsInfo.new(
      Invoice.actives.current_year.sum('taxable_income'), 
      Invoice.actives.current_year.sum('tax'), 
      Invoice.actives.current_year.sum('total'))
  end

  def new
    @invoice = Invoice.create_new    
    @customers = Customer.all
    @totals = InvoiceTotalsInfo.new(0, 0, 0)
    @iva = AppSettings.iva
  end

  def create
    invoice = Invoice.new(params[:invoice])
    invoice.customer = Customer.find(params[:invoice][:customer_id])
    invoice.invoice_items = invoice.invoice_items.to_a.delete_if {|i| i.description.empty?}
    invoice.save
    #@invoice.save #TODO: why update_totals doesn't work if I don't call save twice?
    redirect_to invoices_path
  end

  def activate
    invoice = Invoice.find(params[:invoice_id])
    invoice.activate
    invoice.save
    redirect_to invoices_path
  end

  def edit  
    @invoice = Invoice.find(params[:id])
    @customers = Customer.all 
    @totals = InvoiceTotalsInfo.new(@invoice.taxable_income, @invoice.tax, @invoice.total)
    @iva = AppSettings.iva
  end

  def update  
    invoice = Invoice.find(params[:id])
    invoice.update_attributes!(params[:invoice])
    invoice.status = Invoice.active unless invoice.number.nil?
    invoice.save
    redirect_to invoices_path
  end
  
  def destroy
    invoice = Invoice.find(params[:id])
    invoice.destroy
    redirect_to invoices_url
  end

  def show
    @invoice = Invoice.find(params[:id])
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}.pdf"
    render :pdf => file_name,
      :template => 'invoices/show.pdf.html.erb',
      :margin => { :bottom => 20, :top => 10 },
      :footer => { :content => AppSettings.footer }
  end

  def drop_box
    @invoice = Invoice.find(params[:invoice_id])
    file_name = "#{@invoice.number} - #{@invoice.customer.file_name_template}.pdf"
    full_path = Rails.root.join('tmp', file_name)
  
    pdf = render_to_string(
            :pdf => file_name,
            :template => 'invoices/show.pdf.html.erb',
            :margin => { :bottom => 20, :top => 10 },
            :footer => { :content => AppSettings.footer })
    
    if AppSettings.dropbox_enabled == 'true'
      drop_box = DropBoxService.new
      drop_box.upload file_name, pdf
    end
    render :json => {satus: 'success'}
  end

  def clone
    invoice = Invoice.find(params[:invoice_id])
    new_invoice = invoice.clone
    new_invoice.save

    redirect_to invoices_path
  end
end
