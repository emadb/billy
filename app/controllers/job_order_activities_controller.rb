class JobOrderActivitiesController < ApplicationController
  def index
  	job_order = JobOrder.find(params[:job_order_id])
  	@job_order_activities = job_order.active_activities.select('id, description')
  	respond_to do |format|
      format.json { render :json => @job_order_activities }
    end
  end
end
