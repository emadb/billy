class WeeklyActivitiesController < ApplicationController

  def index
    @week = DateTime.now.all_week
    # monday = DateTime.now.beginning_of_week
    # activities = UserActivity.
    #   .where('date >= ? and date <= ? and user_id = ?', monday, monday + 7, current_user.id)
  end

  def create
    activites = params[:weekly_activity][:_json]
    activites.each do |a|
      7.times do |d|
        act = UserActivity.new 
        act.user_activity_type_id = UserActivityType.working_id
        act.job_order_activity_id = a[:activity_id]
        act.user = current_user
        act.date = DateTime.now.beginning_of_week + d
        act.hours = a[:hours][d]        
        act.save
      end
    end
    redirect_to '/user_activites'
  end

end