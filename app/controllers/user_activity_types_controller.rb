class UserActivityTypesController < ApplicationController
  def index
    @user_activities_type = UserActivityType.all
    logger.warn '##################################'
    logger.warn @user_activities_type.size
     respond_to do |format|
      format.json { render :json => @user_activities_type }
    end
  end
end