class UserActivitiesController < ApplicationController
  def index
    if (params[:year].nil? or params[:month].nil?)
      @filter_date  = Date.today
    else
      @filter_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
    
    if (current_user.admin?)
      @users = User.all
    else
      @users = [current_user]  
    end

    if (params[:user].nil?)
      user = current_user
    else
      user = User.find(params[:user])
    end
    
    @activities = UserActivity.get(params[:year], params[:month], user.id)

    respond_to do |format|
      format.html
      format.json { render :json => @activities.map{ |a| {
          :id => a.id,
          :date => a.date,
          :hours => a.hours,
          :description => a.description,
          :jobOrder => a.job_order_activity.job_order.code,
          :activity => a.job_order_activity.description
        }} }
    end
  end

  def show
    activity = UserActivity.find(params[:id])
    render :json => activity
  end

  def create
    if params[:id].nil?
      activity = UserActivity.new
    else
      activity = UserActivity.find(params[:id])
    end
    create_or_update activity
    create_response activity
  end

  def update
    activity = UserActivity.find(params[:id])
    create_or_update activity
    create_response activity
  end

  def create_response(activity)
    @result = {
      :id => activity.id,
      :date => activity.date,
      :hours => activity.hours,
      :description => activity.description,
      :jobOrder => activity.job_order_activity.job_order.code,
      :activity => JobOrderActivity.find(activity.job_order_activity.id).description
    }

    respond_to do |format|
      format.html { render :json =>  @result }
      format.json { render :json =>  @result }
    end
  end

  def create_or_update(activity)
    activity.date = DateTime.parse(params[:date])
    activity.hours = params[:hours].to_f
    activity.description = params[:description]
    job_order = JobOrder.find(params[:jobOrder])
    activity.job_order_activity = job_order.activities.select{|a| a.id = params[:activity]}[0]
    activity.user = current_user
    activity.save
  end

  def destroy
    UserActivity.find(params[:id]).delete
    respond_to do |format|
      format.html { render :json => {result: 'ok'} }
      format.json { render :json => {result: 'ok'} }
    end      
  end

  def stats
    user = User.find(params[:user])
    
    stats = ActivityStats.new
    stats.today_hours = UserActivity.sum(:hours, :conditions => ["user_id = ? and DATE(date) = ?", user.id, Date.today.to_date])
    stats.yesterday_hours = UserActivity.sum(:hours, :conditions => ["user_id = ? and DATE(date) = ?", user.id, Date.yesterday.to_date])

    render :json => stats
  end

  def report
    @activities = UserActivity.get(params[:year], params[:month], params[:user])
    respond_to do |format|
      format.xls 
    end
  end

end



