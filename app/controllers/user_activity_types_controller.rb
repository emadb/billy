class UserActivityTypesController < ApplicationController
  
  def index
    @user_activities_type = UserActivityType.all
    
    respond_to do |format|
      format.json { render :json => @user_activities_type }
    end
  end
end