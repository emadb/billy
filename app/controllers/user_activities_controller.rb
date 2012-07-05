class UserActivitiesController < ApplicationController
  def index
    if (params[:date].nil?)
      @filter_date  = Date.today
    else
      @filter_date= Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
    end
    filter_date_next = @filter_date.to_time.advance(:months => 1).to_date
    @activities = UserActivity
      .where(:date.gte => @filter_date)
      .where(:date.lte => filter_date_next)
      .order_by([:due_date, :desc])
  
    respond_to do |format|
      format.html
      format.xml  { render :xml => @activities }
      format.json { render :json => @activities }
    end
  end

  def create
    #{"type"=>"1", "date"=>"11-04-2012", "hours"=>"10", "description"=>"provpa", "jobOrder"=>"4ff59c05c788e13c52000002", "activity"=>"4fe48164412b6c841b000004", "action"=>"create", "controller"=>"user_activities"}
    @activity = UserActivity.new()
    
    @activity.type = UserActivityType.find(params[:type])
    @activity.date = DateTime.parse(params[:date])
    @activity.hours = Float.parse(params[:hours])
    @activity.description = params[:description]
    @activity.activity = JobOrder.find(params[:jobOrder]).select{|a| a._id = params[:activity]}[0]
    @activity.user = current_user
    @activity.save
    respond_to do |format|
      format.html { render :json => {:result => 'ok'} }
      format.json { render :json => {:result => 'ok'} }
    end      
  end

end