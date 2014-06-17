class SettingsController < ApplicationController
  before_filter :user_is_admin?

  def index
    @settings = Setting.all
  end

  def update
    params.each do |key, value| 
      setting = Setting.where(:key => key).first
      unless setting.nil?
        setting.value = value
        setting.save
      end
    end
    AppSettings.init
    redirect_to '/settings'
  end
end
