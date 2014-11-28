class WeeklyActivitiesController < ApplicationController

  def index
    @week = DateTime.now.all_week
  end

  def create
  end

end