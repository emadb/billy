class UserActivitiesController < ApplicationController
  def index
    if (params[:year].nil? or params[:month].nil?)
      @filter_date  = Date.today
    else
      @filter_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    end

    if (params[:user].nil?)
      user = current_user
    else
      user = User.find(params[:user])
    end
    
    @activities = UserActivity.get(params[:year], params[:month], user.id)

    view_model = @activities.map do |a| 
      create_view_model(a)
    end

    if (current_user.admin?)
      @users = User.all
    else
      @users = [current_user]  
    end

    respond_to do |format|
      format.html
      format.json { render :json => view_model }
    end
  end

  def create_view_model(activity)
    result = {
      :id => activity.id,
      :date => activity.date,
      :hours => activity.hours,
      :description => activity.description,
      :user_activity_type_id => activity.user_activity_type.id,
    }
    if activity.user_activity_type.working?
      result[:jobOrder] = activity.job_order_activity.job_order.code
      result[:activity] = activity.job_order_activity.description 
    end
    result
  end

  def show
    activity = UserActivity.find(params[:id])
    render :json => activity
  end

  def create
    activity = UserActivity.find_or_create_by(id: params[:id])
    create_or_update activity
    create_response activity
  end

  def update
    activity = UserActivity.find(params[:id])
    create_or_update activity
    create_response activity
  end

  def create_response(activity)
    @result = create_view_model(activity)
    respond_to do |format|
      format.html { render :json =>  @result }
      format.json { render :json =>  @result }
    end
  end

  def create_or_update(activity)
    activity.date = DateTime.parse(params[:date])
    activity.hours = params[:hours].to_f
    activity.description = params[:description]
    user_activity_type_id = params[:user_activity_type_id] || UserActivityType.working_id
    activity.user_activity_type = UserActivityType.find(user_activity_type_id)
    if activity.user_activity_type.working?
      job_order = JobOrder.find(params[:job_order_id])
      activity.job_order_activity = job_order.activities.select{|a| a.id = params[:job_order_activity_id]}[0]
    end
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
    user = current_user 
    
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



