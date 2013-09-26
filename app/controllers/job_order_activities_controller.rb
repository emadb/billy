class JobOrderActivitiesController < ApplicationController
  def index
  	job_order = JobOrder.find(params[:job_order_id])
  	@job_order_activities = job_order.active_activities.select('id, description')
  	respond_to do |format|
      format.json { render :json => @job_order_activities }
    end
  end

  def show
    @job_order_activity = JobOrderActivity.find(params[:id])
    respond_to do |format|
      format.json { render :json => @job_order_activity }
    end    
  end
end
