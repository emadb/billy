class UserActivitiesController < ApplicationController
  def index
    @filter_date = parse_filter(params)
    
    user_id = params[:user] || current_user.id
    
    @activities = UserActivity.get(params[:year], params[:month], user_id)

    if (current_user.admin?)
      @users = User.all
    else
      @users = [current_user]  
    end

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

  def report_2
    from_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    to_date = from_date + 1.month
    user_id = params[:user]

    activities = ActiveRecord::Base.connection.select_all("
      select date, user_activity_type_id, sum(hours) as hours
      from user_activities
      where date >= '#{from_date.strftime('%Y-%m-%d')}' and date <= '#{to_date.strftime('%Y-%m-%d')}'
      and user_id = #{user_id}
      group by date, user_activity_type_id
      order by date")

    @formatted_activities = []
    logger.info '################## w: '+ UserActivityType.working_id.to_s
    (from_date..to_date).each do |d|
      r = ReportRow.new(d)
      @formatted_activities << r
      logger.info 'data: ' + d.to_s
      activities_of_the_day = activities.select {|f| f['date'] == d.to_s}
      activities_of_the_day.each do |a|
        logger.info 'a = ' + a['user_activity_type_id'].to_s
        logger.info '== ' + (a['user_activity_type_id'] == UserActivityType.working_id).to_s
        if a['user_activity_type_id'].to_s == UserActivityType.working_id.to_s
          logger.info 'working: ' + a['hours'].to_s 
          r.working_hours = a['hours']
        else
          logger.info 'holiday: ' + a['hours'].to_s
          r.holiday_hours = a['hours']
        end
      end
    end
    @month = from_date.strftime("%B")
    @user_name = User.find(user_id).name
    respond_to do |format|
      format.xls 
    end
  end

  class ReportRow
    attr_accessor :date, :working_hours, :holiday_hours
    def initialize(date)
      @date = date    
    end
  end

end


