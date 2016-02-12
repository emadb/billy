class UserActivitiesController < ApplicationController
  def index
    @filter_date = parse_filter(params)
    
    user_id = params[:user] || current_user.id
    
    @activities = UserActivity.get(params[:year], params[:month], user_id)

    load_users

    respond_to do |format|
      format.html
      format.json do 
        view_model = @activities.map do |a| 
          create_view_model(a)
        end
        render :json => view_model 
      end
    end
  end

  def load_users
    if (current_user.admin?)
      @users = User.all
    else
      @users = [current_user]  
    end
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
    stats.today_hours = UserActivity.where("user_id = ? and DATE(date) = ?", user.id, Date.today.to_date).sum(:hours)
    stats.yesterday_hours = UserActivity.where("user_id = ? and DATE(date) = ?", user.id, Date.yesterday.to_date).sum(:hours)

    render :json => stats
  end

  def report
    @activities = UserActivity.get(params[:year], params[:month], params[:user])
    respond_to do |format|
      format.xls 
    end
  end

  def report_2
    @formatted_activities = ActivityReport.report_2(params[:year].to_i, params[:month].to_i, params[:user])
    @month = Date.new(params[:year].to_i, params[:month].to_i, 1).strftime("%B")
    @user_name = User.find(params[:user]).name
    respond_to do |format|
      format.xls 
    end
  end

  def report_presenze
    @formatted_activities = ActivityReport.report_presenze(params[:year].to_i, params[:month].to_i)
    @month = Date.new(params[:year].to_i, params[:month].to_i, 1).strftime("%B")
    @user_name = 'FOOO'
    respond_to do |format|
      format.xls 
    end
  end

  private

  def parse_filter (params)
    if (params[:year].nil? or params[:month].nil?)
      Date.today
    else
      Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
  end

  def create_view_model(activity)
    result = {
      :id => activity.id,
      :date => activity.date,
      :hours => activity.hours,
      :description => activity.description,
      :user_activity_type_id => activity.user_activity_type.id,
      :expenses => activity.expenses.count > 0
    }
    if activity.user_activity_type.working?
      if !activity.job_order_activity.nil? # this shouldn't happens...but it do.
        result[:jobOrder] = activity.job_order_activity.job_order.code
        result[:activity] = activity.job_order_activity.description 
      end
    end
    result
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
    activity.user = current_user

    user_activity_type_id = params[:user_activity_type_id] || UserActivityType.working_id
    activity.user_activity_type = UserActivityType.find(user_activity_type_id)
    if activity.user_activity_type.working?
      activity.job_order_activity = get_job_order(params[:job_order_id])
    end
    
    activity.save
  end

  def get_job_order (job_order_id)
    job_order = JobOrder.find(job_order_id)
    job_order.activities.select{|a| a.id == params[:job_order_activity_id]}.first
  end

end


