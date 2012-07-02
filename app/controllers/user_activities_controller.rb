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
end