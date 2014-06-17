class ActivitiesTrackerController < ApplicationController
  def index
    
  end

  def today
    activities = ActivityTracker.today.where(user: current_user).map do |a|
      {
        id: a.id,
        jobOrder: a.job_order_activity.job_order.code,
        activity: a.job_order_activity.description,
        time: a.time,
        job_order_id: a.job_order_activity.job_order.id,
        job_order_activity_id: a.job_order_activity.id,
        notes: a.notes,
        start_time: a.start_time.strftime('%H:%M'),
        stop_time: a.stop_time.strftime('%H:%M')
      }
    end
    render :json => activities
  end

  def create
    newActivity = ActivityTracker.new(tracker_params)
    newActivity.date = Date.today
    newActivity.user = current_user
    newActivity.status = ActivityTracker.untracked
    newActivity.save!

    render :json => {:status => 'success', :activityId => newActivity.id}  
  end

  def destroy
    ActivityTracker.destroy(params[:id])  
    render :json => {:status => 'success'}  
  end

  def update
    activity = ActivityTracker.find(params[:id])
    activity.update_attributes(tracker_params)
    activity.save
    render :json => {:status => 'success'}  
  end

  private
  def tracker_params
    params.require(:activities_tracker).permit(:job_order_activity_id, :time, :notes, :status, :start_time, :stop_time)
  end
end