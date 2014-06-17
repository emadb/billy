class UserActivityTypesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render :json => UserActivityType.all } 
    end
  end
end