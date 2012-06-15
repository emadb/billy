class JobOrdersController < ApplicationController
  def index
    @job_orders = JobOrder.all
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
    @job_order.save
    redirect_to job_orders_path
  end

  def update
    @job_order = JobOrder.find(params[:id])
    @job_order.update_attributes!(params[:job_order])
    redirect_to job_orders_path
  end

  def destroy
    @job_order = JobOrder.find(params[:id])
    @job_order.destroy

    respond_to do |format|
      format.html { redirect_to job_orders_url }
      format.json { head :no_content }
    end
  end
end
