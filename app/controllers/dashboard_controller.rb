class DashboardController < ApplicationController
  before_filter :user_is_admin?
  def index
    
  end

  def invoices
    invoices = Invoice.where(:status => Invoice.active)
    @to_receive = 0
    invoices.each{ |x| @to_receive = @to_receive + (x.total || 0) unless x.is_payed }
    @invoices_totals = InvoiceTotalsInfo.new(Invoice.sum(:taxable_income), Invoice.sum(:tax), Invoice.sum(:total))
    render :layout=> false
  end

  def quarters
    invoices = Invoice.where(:status => Invoice.active)
    @quarters = Quarters.new
    #TODO: refactor this...it's too c-sharpy!
    invoices.each do |i|
      @quarters.q1  = @quarters.q1 + i.taxable_income if [1,2,3].include?(i.date.month)
      @quarters.q2  = @quarters.q2 + i.taxable_income if [4,5,6].include?(i.date.month)
      @quarters.q3  = @quarters.q3 + i.taxable_income if [7,8,9].include?(i.date.month)
      @quarters.q4  = @quarters.q4 + i.taxable_income if [10, 11, 12].include?(i.date.month)
    end
    render :layout=> false
  end

  def per_customer
    @perCustomer = ActiveRecord::Base.connection.select_all("select customers.name as customer, sum(total) as total, sum(taxable_income) as taxable_income, sum(tax) as tax 
        from invoices join customers on invoices.customer_id = customers.id 
        group by customers.name")
    render :layout=> false
  end

  def inbound_invoices
    inbound_invoices = InboundInvoice.all
    @inbound_invoices_totals = InvoiceTotalsInfo.new(InboundInvoice.sum(:taxable_income), 
      InboundInvoice.sum(:tax), 
      InboundInvoice.sum(:total))
    render :layout=> false
  end

  def job_orders
    @job_orders = JobOrder.where(:archived => false).order('code')
    render :layout=> false
  end

  def activities
    month = params['month'].to_i 
    year = params['year'].to_i

    from_date = Date.new(year, month, 1)
    to_date = from_date + 1.month

    @filter_date = from_date
    
    @activities = ActiveRecord::Base.connection.select_all("
      SELECT users.name, job_orders.code, sum(user_activities.hours) as total 
      FROM user_activities 
      INNER JOIN users ON users.id = user_activities.user_id
      INNER JOIN job_order_activities ON user_activities.job_order_activity_id = job_order_activities.id
      INNER JOIN job_orders on job_order_activities.job_order_id = job_orders.id
      WHERE user_activities.date >= '#{from_date.strftime('%Y-%m-%d')}' and user_activities.date <= '#{to_date.strftime('%Y-%m-%d')}'
      GROUP BY users.name, job_orders.code
      ORDER BY job_orders.code, users.name")

    # @activities = UserActivity
    #   .joins(:user)
    #   .select('users.name, sum(user_activities.hours) as total')
    #   .where('date >= ? and date < ?', Date.new(2013,1,1), Date.new(2013,2,1))
    render :layout=> false
  end
end






