class JobOrderActivitiesController < ApplicationController
  before_filter :user_is_admin?
  def index
  	job_order = JobOrder.find(params[:job_order_id])
  	@job_order_activities = job_order.activities
  	respond_to do |format|
      format.json { render :json => @job_order_activities }
    end
  end
end
