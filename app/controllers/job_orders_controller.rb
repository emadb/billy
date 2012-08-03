class JobOrdersController < ApplicationController
  def index
    if params[:archived] == "yes"
      @job_orders = JobOrder.where(archived: '1')
      @title = 'Archived job orders'
    else
      @job_orders = JobOrder.where(archived: '0')
      @title = 'Job orders'
    end
    respond_to do |format|
      format.html
      format.json { render :json => @job_orders }
    end
  end

  def new
    @job_order = JobOrder.create_new
    @customers = Customer.all
  end

  def edit
    @job_order = JobOrder.find(params[:id])
    @customers = Customer.all
  end

  def create
    @job_order = JobOrder.new(params[:job_order])
    @job_order.customer = Customer.find(params[:job_order][:customer_id])
    @job_order.activities = @job_order.activities.delete_if {|a| a.description.empty?}
    @job_order.activities.each { |a| a.job_order_code = @job_order.code }
    @job_order.save
    redirect_to job_orders_path
  end

  def update
    @job_order = JobOrder.find(params[:id])
    @job_order.update_attributes!(params[:job_order])
    @job_order.activities.each { |a| a.job_order_code = @job_order.code }
    redirect_to job_orders_path
  end

  def destroy
    @job_order = JobOrder.find(params[:id])
    @job_order.destroy
    redirect_to job_orders_path
  end

  def show
    @job_order = JobOrder.find(params[:id])
    respond_to do |format|
      format.json { render :json => @job_order }
    end
  end
end