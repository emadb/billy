class WeeklyActivitiesController < ApplicationController

  def index
    if params[:startday].nil?
      @startday = DateTime.now.beginning_of_week
    else
      @startday = Date.parse(params[:startday]) 
    end
    @week = @startday.all_week
  end

  def get_current_week
    monday = startdate(params[:startday])

    activities = UserActivity.select('job_order_id as joid, job_order_activity_id as id, date , sum(hours) as hours')
      .joins('inner join job_order_activities joa on job_order_activity_id = joa.id')
      .where('date >= ? and date <= ? and user_id = ?', monday, monday + 7, current_user.id)
      .group('job_order_id')
      .group('job_order_activity_id')
      .group('date')
      .order('job_order_activity_id, date')

    @result = {}
    current_activity = nil
    activities.each do |act|
      if @result[act.id].nil?
        @result[act.id] = {:jid => 0, :hours => [0,0,0,0,0,0,0]};
      end
      @result[act.id][:jid] = act.joid
      @result[act.id][:hours][act.date.wday - 1] = act.hours
    end

    render :json => @result
  end

  def create
    monday = startdate(params[:startday])
    UserActivity.where('date >= ? and date <= ? and user_id = ?', monday, monday + 7, current_user.id).destroy_all
    activites = params[:weekly_activity][:_json]
    activites.each do |a|
      7.times do |d|
        if a[:hours][d].to_i > 0
          act = UserActivity.new 
          act.user_activity_type_id = UserActivityType.working_id
          act.job_order_activity_id = a[:activity_id]
          act.user = current_user
          act.date = monday + d
          act.hours = a[:hours][d]        
          act.save
        end
      end
    end
    redirect_to action: "index"
  end

  def startdate(p)
    if p.nil? || p.empty?
      monday = DateTime.now.beginning_of_week
    else
      monday = Date.parse(p)
    end
  end

end