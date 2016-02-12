class JobOrdersController < ApplicationController
  before_filter :user_is_admin?, :except => [:index]

  def index
    if params[:archived] == "yes"
      @job_orders = JobOrder.where(:archived => true).order('code')
      @title = 'Archived job orders'
    else
      @job_orders = JobOrder.where(:archived => false).order('code')
      @title = 'Job orders'
    end
    
    respond_to do |format|
      format.html do 
        if current_user.admin? 
          @job_orders 
        else
          redirect_to root_path
        end

      end
      format.json { render :json => @job_orders.select('id, code').order('code') }
    end
  end

  def new
    @job_order = JobOrder.create_new
    @customers = Customer.all
  end

  def edit
    @job_order = JobOrder.find(params[:id])
    @job_order.activities.push(JobOrderActivity.new) unless @job_order.activities.count > 0
    @customers = Customer.all
    @total_estimated_hours = @job_order.total_estimated_hours
  end

  def create
    @job_order = JobOrder.new(params[:job_order])
    @job_order.customer = Customer.find(params[:job_order][:customer_id])
    @job_order.activities = @job_order.activities.to_a.delete_if {|a| a.description.empty?}
    @job_order.activities.each { |a| a.job_order_id = @job_order.id }
    @job_order.save
    redirect_to job_orders_path
  end

  def update
    @job_order = JobOrder.find(params[:id])
    @job_order.update_attributes!(params[:job_order])
    @job_order.activities.each do |a| 
      if a.description.empty?
        a.delete
      else
        a.job_order_id = @job_order.id 
      end
    end
    @job_order.save
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

  def activities

    if params[:date].nil? or params[:date][:month].nil? or params[:date][:month].blank?
      @month = Date.today.month
    else
      @month = params[:date][:month].to_i
    end

    if params[:date].nil? or params[:date][:year].nil? or params[:date][:year].blank?
      @year = Date.today.year
    else
      @year = params[:date][:year].to_i
    end

    start_date = Date.new(@year, @month, 1)
    end_date = start_date + 1.month

    logger.info 'EMA'
    logger.info params


    @user_activities = UserActivity
      .joins(job_order_activity: [:job_order])
      .where('job_order_id = ?', params[:job_order_id])
      .where(date: start_date..end_date)
      .order(:date)
    @job_order = JobOrder.find(params[:job_order_id])
  end
end



