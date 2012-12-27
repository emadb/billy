class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!


  def user_is_admin?
    if not current_user.admin?
      redirect_to user_activities_url, :alert => 'solo admin'
    end
  end
end
